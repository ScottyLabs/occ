{
  ceph = {
    fsid = "6b326148-3642-46cf-9ee8-752acd8aff0d";
    mons = [ "mimosa" ];
    mgrs = [ "mimosa" ];
  };

  hosts = {
    mimosa = {
      system = "aarch64-linux";
      address = "128.2.96.10";
      osds = [ "0" ];
    };
  };
}
