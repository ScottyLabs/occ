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
        preseed.config = {
          "core.https_address" = "${host.address}:8443";
          "acme.domain" = "incus.occ.build";
          "acme.email" = "admin@scottylabs.org";
          "acme.agree_tos" = "true";
          "acme.challenge" = "DNS-01";
          "acme.provider" = "cloudflare";
        };
      };

      sops = {
        secrets.cloudflare-token.sopsFile = ../../secrets/acme.yaml;
        templates."incus-acme.env" = {
          content = "CF_DNS_API_TOKEN=${config.sops.placeholder.cloudflare-token}\n";
          restartUnits = [ "incus.service" ];
        };
      };
      # incus runs lego with its own environment, so the token stays out of the preseed and incus's config
      systemd.services.incus.serviceConfig.EnvironmentFile = config.sops.templates."incus-acme.env".path;

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
