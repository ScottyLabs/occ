let
  cluster = import ../../cluster.nix;
in
{
  flake.modules.nixos.incus =
    { config, lib, ... }:
    let
      host = cluster.hosts.${config.networking.hostName};
    in
    {
      virtualisation.incus = {
        enable = true;
        ui.enable = true;
        preseed.config."core.https_address" = "${host.address}:8443";
      };

      # incus requires the nftables backend
      networking.nftables.enable = true;

      # allow api and ui traffic from cluster hosts only
      networking.firewall.extraInputRules =
        let
          peers = lib.concatMapStringsSep ", " (h: h.address) (lib.attrValues cluster.hosts);
        in
        "ip saddr { ${peers} } tcp dport 8443 accept";
    };
}
