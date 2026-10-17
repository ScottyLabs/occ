{ config, inputs, ... }:
{
  # Base layer composed onto every host
  flake.modules.nixos.global = {
    imports = [
      config.flake.modules.nixos.base
      config.flake.modules.nixos.ceph
      config.flake.modules.nixos.incus
      config.flake.modules.nixos.bridge
      config.flake.modules.nixos.ipv6-tunnel
      config.flake.modules.nixos.ipv6-wireguard
      config.flake.modules.nixos.instance-ipv6
      config.flake.modules.nixos.sops

      inputs.srvos.nixosModules.server
      inputs.srvos.nixosModules.mixins-systemd-boot
      inputs.srvos.nixosModules.mixins-nix-experimental
      inputs.srvos.nixosModules.mixins-terminfo
      inputs.srvos.nixosModules.mixins-trusted-nix-caches
      { srvos.flake = inputs.self; }

      inputs.sops-nix.nixosModules.sops
    ];
  };
}
