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
      hostName = config.networking.hostName;
      ceph = cluster.ceph;
      osds = cluster.hosts.${hostName}.osds or [ ];
    in
    {
      # incus boots vms from rbd images
      nixpkgs.overlays = [
        (_: prev: { qemu_kvm = prev.qemu_kvm.override { cephSupport = true; }; })
      ];

      services.ceph = {
        enable = true;
        # incusd needs the ceph CLI on its PATH
        client.enable = true;
        global = {
          fsid = ceph.fsid;
          monInitialMembers = lib.concatStringsSep "," ceph.mons;
          monHost = lib.concatMapStringsSep "," (n: "[v2:${cluster.hosts.${n}.address}:3300]") ceph.mons;
        };
        extraConfig = {
          "auth allow insecure global id reclaim" = "false";
          "ms bind msgr1" = "false";
          "ms cluster mode" = "secure";
          "ms service mode" = "secure";
          "ms client mode" = "secure";
          "ms mon cluster mode" = "secure";
          "ms mon service mode" = "secure";
          "ms mon client mode" = "secure";
          "rbd default map options" = "ms_mode=secure";
          "mon allow pool size one" = "true";
          "osd pool default size" = "1";
          "osd pool default min size" = "1";
        };
        mon = {
          enable = lib.elem hostName ceph.mons;
          daemons = [ hostName ];
        };
        mgr = {
          enable = lib.elem hostName ceph.mgrs;
          daemons = [ hostName ];
        };
        osd = {
          enable = osds != [ ];
          daemons = osds;
          # drop the module's size 3 and fixed pg count defaults
          extraConfig = { };
        };
      };

      environment.systemPackages = [ pkgs.ceph ];

      # allow mon (3300) and mgr/osd (6800-7300) traffic from cluster hosts only
      networking.firewall.extraInputRules =
        let
          peers = lib.concatMapStringsSep ", " (h: h.address) (lib.attrValues cluster.hosts);
        in
        "ip saddr { ${peers} } tcp dport { 3300, 6800-7300 } accept";

      virtualisation.incus.preseed = {
        storage_pools = [
          {
            name = "ceph";
            driver = "ceph";
            config."ceph.osd.pool_name" = "incus";
          }
        ];
        profiles = [
          {
            name = "default";
            devices.root = {
              type = "disk";
              path = "/";
              pool = "ceph";
            };
          }
        ];
      };
    };
}
