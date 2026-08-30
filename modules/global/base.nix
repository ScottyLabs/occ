let
  cluster = import ../../cluster.nix;
in
{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      boot.kernelPackages = pkgs.linuxPackages_latest;

      nix.gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };

      networking.nftables.enable = true;

      users.users.root.openssh.authorizedKeys.keys = cluster.adminKeys;

      environment.systemPackages = [ pkgs.smartmontools ];
    };
}
