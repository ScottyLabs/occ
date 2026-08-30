{
  flake.modules.nixos.mimosa-configuration = {
    networking.hostName = "mimosa";

    system.stateVersion = "26.05";
  };
}
