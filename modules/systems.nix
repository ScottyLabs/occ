{
  config,
  inputs,
  lib,
  ...
}:
let
  nixos = config.flake.modules.nixos;
  cluster = import ../cluster.nix;
in
{
  flake.nixosConfigurations = lib.mapAttrs (
    hostname: host:
    inputs.nixpkgs.lib.nixosSystem {
      inherit (host) system;
      specialArgs = { inherit inputs; };
      modules = [
        nixos.${hostname}
        nixos.global
      ];
    }
  ) cluster.hosts;
}
