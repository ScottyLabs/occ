{
  flake.modules.nixos.mimosa-configuration =
    { config, ... }:
    {
      networking.hostName = "mimosa";

      # mimosa bootstraps the incus cluster
      virtualisation.incus.preseed.cluster = {
        server_name = config.networking.hostName;
        enabled = true;
      };

      system.stateVersion = "26.05";
    };
}
