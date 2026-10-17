let
  cluster = import ../../../cluster.nix;
in
{
  flake.modules.nixos.bridge =
    { config, ... }:
    let
      host = cluster.hosts.${config.networking.hostName};
    in
    {
      systemd.network = {
        # virtual switch shared by the host and its instances
        netdevs."10-br0".netdevConfig = {
          Kind = "bridge";
          Name = "br0";
          # keep the physical port's mac so cmu's dhcp still recognizes the host
          MACAddress = host.mac;
        };

        # plug the physical port into br0
        networks."10-uplink" = {
          matchConfig.PermanentMACAddress = host.mac;
          networkConfig.Bridge = "br0";
        };

        # the host's own ipv4 address lives on br0
        networks."10-br0" = {
          matchConfig.Name = "br0";
          networkConfig.DHCP = "ipv4";
        };
      };

      virtualisation.incus.preseed.profiles = [
        {
          name = "default";
          # each instance's ipv4 nic, plugged into br0 and limited to its own mac
          devices.eth0 = {
            type = "nic";
            nictype = "bridged";
            parent = "br0";
            name = "eth0";
            "security.mac_filtering" = "true";
          };
        }
      ];
    };
}
