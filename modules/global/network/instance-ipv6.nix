let
  cluster = import ../../../cluster.nix;
in
{
  flake.modules.nixos.instance-ipv6 =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      # routed nics need the host to forward ipv6
      boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = 1;

      # each host's /64, for occ-instance-ipv6
      environment.etc."occ/ipv6-prefixes.json".text = builtins.toJSON (
        lib.mapAttrs (_: host: host.ipv6Prefix) cluster.hosts
      );

      environment.systemPackages = [
        # sets an instance's ipv6 address (create-an-instance runbook)
        (pkgs.writeShellApplication {
          name = "occ-instance-ipv6";
          runtimeInputs = [
            config.virtualisation.incus.clientPackage
            pkgs.ipv6calc
            pkgs.jq
          ];
          text = builtins.readFile ./instance-ipv6.sh;
        })
      ];
    };
}
