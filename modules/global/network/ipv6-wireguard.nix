let
  cluster = import ../../../cluster.nix;
  tunnelHost = cluster.ipv6.tunnel.host;
  port = 51820;
in
{
  flake.modules.nixos.ipv6-wireguard =
    { config, lib, ... }:
    let
      hostName = config.networking.hostName;
      otherHosts = lib.attrNames (removeAttrs cluster.hosts [ tunnelHost ]);

      wireguard = peers: {
        netdevConfig = {
          Kind = "wireguard";
          Name = "wg0";
        };
        wireguardConfig = {
          PrivateKeyFile = config.sops.secrets.wireguard-key.path;
          ListenPort = port;
        };
        wireguardPeers = peers;
      };
      publicKey = name: lib.trim (builtins.readFile ../../../keys/hosts/${name}/wg.pub);

      allowFrom =
        names:
        "ip saddr { ${
          lib.concatMapStringsSep ", " (name: cluster.hosts.${name}.address) names
        } } udp dport ${toString port} accept";
    in
    {
      config = lib.mkMerge [
        # the tunnel host only needs a key once another host exists
        (lib.mkIf (hostName != tunnelHost || otherHosts != [ ]) {
          sops.secrets.wireguard-key = {
            sopsFile = ../../../secrets/hosts/${hostName}.yaml;
            owner = "systemd-network";
          };
        })

        # the tunnel host routes each other host's /64 to it
        (lib.mkIf (hostName == tunnelHost && otherHosts != [ ]) {
          systemd.network = {
            netdevs."30-wg0" = wireguard (
              map (name: {
                PublicKey = publicKey name;
                AllowedIPs = [ cluster.hosts.${name}.ipv6Prefix ];
              }) otherHosts
            );
            networks."30-wg0" = {
              matchConfig.Name = "wg0";
              routes = map (name: { Destination = cluster.hosts.${name}.ipv6Prefix; }) otherHosts;
            };
          };
          networking.firewall.extraInputRules = allowFrom otherHosts;
        })

        # every other host sends all its ipv6 to the tunnel host
        (lib.mkIf (hostName != tunnelHost) {
          systemd.network = {
            netdevs."30-wg0" = wireguard [
              {
                PublicKey = publicKey tunnelHost;
                AllowedIPs = [ "::/0" ];
                Endpoint = "${cluster.hosts.${tunnelHost}.address}:${toString port}";
              }
            ];
            networks."30-wg0" = {
              matchConfig.Name = "wg0";
              routes = [
                { Destination = "::/0"; }
                # unassigned addresses would otherwise bounce back to the tunnel host
                {
                  Destination = cluster.hosts.${hostName}.ipv6Prefix;
                  Type = "unreachable";
                }
              ];
            };
          };
          networking.firewall.extraInputRules = allowFrom [ tunnelHost ];
        })
      ];
    };
}
