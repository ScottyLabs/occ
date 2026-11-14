# 17. Patch KVM so guests can reach vCPUs past 15

Date: 2026-11-13

## Status

Accepted

## Context

We run arm64 macOS guests on QEMU's `vmapple` machine. Their kernel lists every CPU in one cluster, numbered 0 to 31 in the affinity field Aff0, and has room for at most 32.

KVM numbers vCPUs with 16 per cluster, so in a guest with more than 16 vCPUs, CPU 16 (zero-indexed) appears as cluster 1, CPU 0. Our QEMU build overrides that numbering for `vmapple`, but KVM also limits interrupts between vCPUs. A guest sends one by writing `ICC_SGI1R_EL1`, whose target list covers 16 CPUs, and its range selector (RS) picks which 16 (`RS * 16` to `RS * 16 + 15`). KVM's distributor reports range selector support (`GICD_TYPER.RSS`) as 0 and `vgic_v3_dispatch_sgi` treats RS as 0, which the GICv3 spec allows in that case, so an interrupt meant for CPU 16 + n goes to CPU n instead. macOS sets RS without checking RSS.

With the same QEMU and firmware changes, macOS 27.2 starts all 32 CPUs (`hw.activecpu: 32`) under QEMU's own emulation, and under KVM with this patch.

## Decision

We will apply a kernel patch on every host that makes KVM honour RS when it delivers these interrupts and advertise `GICD_TYPER.RSS` to guests, so macOS VMs can use more than 16 vCPUs. The patch is in `arch/arm64/kvm/vgic/vgic-mmio-v3.c` and is applied through `boot.kernelPatches` until an equivalent change lands upstream.

## Consequences

Hosts no longer use the binary cache's kernel, so every kernel update is built from source. The first build took 36 minutes on mimosa with 24 cores, and each new kernel needs a reboot to load.

Upstream is unlikely to accept this patch as written. It doesn't fix a bug, since the GICv3 spec allows KVM's current behaviour. An acceptable version would only honour RS when RSS is advertised, and would let userspace choose whether to advertise RSS through a new `GICD_IIDR` revision, so a guest can still migrate to an older host. A 2023 patch that decoded RS without either of these was rejected for these reasons ([review](https://lore.kernel.org/all/86msykg0ox.wl-maz@kernel.org/)). Effecively, our patch enables macOS' noncompliant behaviour.

Guests that number their vCPUs the way KVM does always send RS as 0, which takes the same path as before. They now also see RSS advertised, which Linux guests handle.

On a host without the patch, including one a guest is migrated to, a macOS guest with more than 16 vCPUs has its interrupts for CPUs 16 and up delivered to the wrong CPUs, which can hang the guest or make it misbehave.
