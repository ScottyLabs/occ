{
  ceph = {
    fsid = "6b326148-3642-46cf-9ee8-752acd8aff0d";
    mons = [ "mimosa" ];
    mgrs = [ "mimosa" ];
  };

  openfga.storeId = "01M59HFWMF2ZPV44KBJSYSDJQF";

  ipv6 = {
    prefix = "2001:470:e2be::/48";
    # hurricane electric 6in4 tunnel
    tunnel = {
      host = "mimosa";
      server = "216.66.22.2";
      serverAddress = "2001:470:7:517::1";
      clientAddress = "2001:470:7:517::2/64";
    };
  };

  hosts = {
    mimosa = {
      system = "aarch64-linux";
      address = "128.2.96.10";
      mac = "18:c0:4d:8d:97:a3";
      ipv6Prefix = "2001:470:e2be:1::/64";
      osds = [ "0" ];
      nix.settings = {
        max-jobs = 4;
        cores = 4;
      };
      buildMemoryMax = "8G";
    };
  };
}
