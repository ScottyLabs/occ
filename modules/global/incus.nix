{
  flake.modules.nixos.incus = {
    virtualisation.incus = {
      enable = true;
      ui.enable = true;
    };

    networking.firewall.allowedTCPPorts = [ 8443 ];
    networking.firewall.trustedInterfaces = [ "incusbr0" ];
  };
}
