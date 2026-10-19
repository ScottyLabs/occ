let
  cluster = import ../../cluster.nix;
in
{
  flake.modules.nixos.openfga =
    { config, ... }:
    {
      services.openfga = {
        enable = true;
        settings = {
          datastore.engine = "postgres";
          authn.method = "preshared";
          playground.enabled = false;
        };
        database.createLocally = true;
        environmentFile = config.sops.templates."openfga.env".path;
      };

      sops = {
        secrets.openfga-key.sopsFile = ../../secrets/openfga.yaml;
        templates."openfga.env" = {
          content = "OPENFGA_AUTHN_PRESHARED_KEYS=${config.sops.placeholder.openfga-key}\n";
          restartUnits = [ "openfga.service" ];
        };
      };

      # the preseed is in git, so openfga.api.token is set with `incus config set`
      virtualisation.incus.preseed.config = {
        "openfga.api.url" = "http://${config.services.openfga.settings.http.addr}";
        "openfga.store.id" = cluster.openfga.storeId;
      };
    };
}
