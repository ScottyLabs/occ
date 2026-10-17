let
  cluster = import ../../../cluster.nix;
  inherit (cluster.ipv6) tunnel;
in
{
  flake.modules.nixos.ipv6-tunnel =
    { config, lib, ... }:
    let
      host = cluster.hosts.${config.networking.hostName};
    in
    {
      # only on the host hurricane electric's tunnel ends on
      config = lib.mkIf (config.networking.hostName == tunnel.host) {
        systemd.network = {
          # tunnel to hurricane electric that carries all of our ipv6
          netdevs."20-he-ipv6" = {
            netdevConfig = {
              Kind = "sit";
              Name = "he-ipv6";
              # 1500 minus the 20-byte ipv4 header 6in4 adds
              MTUBytes = 1480;
            };
            tunnelConfig = {
              Local = host.address;
              Remote = tunnel.server;
              TTL = 255;
            };
          };

          # the tunnel's packets travel over br0, which holds the host's ipv4 address
          networks."10-br0".networkConfig.Tunnel = [ "he-ipv6" ];

          networks."20-he-ipv6" = {
            matchConfig.Name = "he-ipv6";
            address = [ tunnel.clientAddress ];
            routes = [
              # all ipv6 leaves through hurricane electric
              { Gateway = tunnel.serverAddress; }
              # unassigned addresses would otherwise bounce back out the tunnel
              {
                Destination = cluster.ipv6.prefix;
                Type = "unreachable";
              }
            ];
          };
        };

        # accept 6in4 packets only from hurricane electric's end
        networking.firewall.extraInputRules = "ip saddr ${tunnel.server} meta l4proto 41 accept";
      };
    };
}
