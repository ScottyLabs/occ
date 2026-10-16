# 3. Store instance disks in Ceph

Date: 2026-10-13

## Status

Accepted

## Context

Incus can keep instance disks on local storage (`dir`, `btrfs`, `lvm`, `zfs`) or on Ceph. With local storage, moving an instance to another host requires copying its disk over the network. With Ceph, every host can attach the disk directly.

mimosa (aarch64) is currently our only host, and the EPYC sleds (x86_64) in the Dell C6400 will join later. Incus can't move instances between architectures, so shared disks only help between hosts of the same architecture.

## Decision

We'll use Incus's `ceph` storage driver. mimosa runs the only Ceph monitor and manager until more hosts join.

## Consequences

Each OSD grows toward the 4 GiB `osd_memory_target` default, which comes out of the memory available to instances on its host.

With one monitor, its database on `nvme0n1` is the only copy of the cluster map and keys. If that disk dies, we can't read anything on the OSDs until we rebuild the monitor database from them by hand.
