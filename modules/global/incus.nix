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
          "core.https_address" = "${host.address}:443";
          "cluster.https_address" = "${host.address}:8443";
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
      systemd.services.incus = {
        # incus runs lego with its own environment, so the token stays out of the preseed and incus's config
        serviceConfig.EnvironmentFile = config.sops.templates."incus-acme.env".path;
        # br0 gets its address from dhcp, and incus only tries to bind the api address once
        wants = [ "systemd-networkd-wait-online@br0.service" ];
        after = [ "systemd-networkd-wait-online@br0.service" ];
      };

      # incus requires the nftables backend
      networking.nftables.enable = true;

      networking.firewall = {
        allowedTCPPorts = [ 443 ];
        # cluster members reach each other on 8443
        extraInputRules =
          let
            peers = lib.concatMapStringsSep ", " (h: h.address) (lib.attrValues cluster.hosts);
          in
          "ip saddr { ${peers} } tcp dport 8443 accept";
      };
    };
}
