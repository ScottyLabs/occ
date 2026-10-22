let
  cluster = import ../../cluster.nix;
in
{
  flake.modules.nixos.incus =
    { config, lib, ... }:
    let
      host = cluster.hosts.${config.networking.hostName};
      oidcClientId = "855326ff-eddb-4634-98af-2e9e12636b08";
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
          "oidc.issuer" = "https://login.microsoftonline.com/e36ee38f-91b8-4dca-9b13-caa5360c9714/v2.0";
          "oidc.client.id" = oidcClientId;
          "oidc.scopes" = "openid,offline_access,email,api://${oidcClientId}/access";
          # entra's v2 access tokens have the client id as their audience
          "oidc.audience" = oidcClientId;
          # andrewid@andrew.cmu.edu
          "oidc.claim" = "preferred_username";
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
