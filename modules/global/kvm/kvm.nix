{
  flake.modules.nixos.kvm = {
    # macOS guests number up to 32 vCPUs in one cluster, which conflicts with KVM only accepting 16 per cluster
    boot.kernelPatches = [
      {
        name = "kvm-vgic-v3-sgi-range-selector";
        patch = ./vgic-v3-sgi-range-selector.patch;
      }
    ];
  };
}
