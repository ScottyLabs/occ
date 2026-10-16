{
  adminKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDwjDM2gTgro+aN81I65BFexfLXq1u/8AJ3PmCTX5X/a i@anish.land"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIABmf+NCxBMyuZukhxuE4fQIAJNf7WQI9ieKq2gUaXba git.cmu.dev from zenbook"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMNCiqUwmemyjJGA7bK+8myy6urHhPrGnGMKJ59h8185 xboxbedrock@gmail.com"
  ];

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
