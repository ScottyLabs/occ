let
  cluster = import ../../cluster.nix;
in
{
  flake.modules.nixos.ceph =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      me = cluster.hosts.${config.networking.hostName};
      mons = lib.filterAttrs (_: h: h.mon) cluster.hosts;
      monNames = lib.attrNames mons;
      monAddrs = map (h: "[v2:${h.address}:3300,v1:${h.address}:6789]") (lib.attrValues mons);
      osdIds = lib.attrNames me.osds;
    in
    {
      services.ceph = {
        enable = true;
        # also puts ceph tools on incusd's PATH
        client.enable = true;
        global = {
          fsid = cluster.fsid;
          monInitialMembers = lib.concatStringsSep "," monNames;
          monHost = lib.concatStringsSep "," monAddrs;
          publicNetwork = cluster.publicNetwork;
        };
        mon = {
          enable = me.mon;
          daemons = lib.optionals me.mon [ config.networking.hostName ];
        };
        mgr = {
          enable = me.mgr;
          daemons = lib.optionals me.mgr [ config.networking.hostName ];
        };
        osd = {
          enable = osdIds != [ ];
          daemons = osdIds;
        };
      };

      # allow mon (3300/6789) and osd/mgr (6800-7300) traffic from cluster hosts only
      networking.firewall.extraInputRules =
        let
          peers = lib.concatStringsSep ", " (map (h: h.address) (lib.attrValues cluster.hosts));
        in
        "ip saddr { ${peers} } tcp dport { 3300, 6789, 6800-7300 } accept";

      environment.systemPackages = [ pkgs.ceph ];
    };
}
