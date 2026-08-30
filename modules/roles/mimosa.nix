{ config, ... }:
{
  flake.modules.nixos.mimosa.imports = with config.flake.modules.nixos; [
    mimosa-configuration
    mimosa-hardware
  ];
}
