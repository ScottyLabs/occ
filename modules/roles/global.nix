{ config, inputs, ... }:
{
  # Base layer composed onto every host
  flake.modules.nixos.global = {
    imports =
      (with config.flake.modules.nixos; [
        base
        ceph
        incus
      ])
      ++ [
        inputs.srvos.nixosModules.server
        inputs.srvos.nixosModules.mixins-systemd-boot
        inputs.srvos.nixosModules.mixins-nix-experimental
        inputs.srvos.nixosModules.mixins-terminfo
        inputs.srvos.nixosModules.mixins-trusted-nix-caches
        { srvos.flake = inputs.self; }
      ];
  };
}
