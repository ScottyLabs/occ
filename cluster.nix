# host registry
{
  fsid = "07197cc5-fac7-4a6e-abd8-f26eb2a02dff";
  publicNetwork = "172.24.96.0/22";

  adminKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDwjDM2gTgro+aN81I65BFexfLXq1u/8AJ3PmCTX5X/a i@anish.land"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIABmf+NCxBMyuZukhxuE4fQIAJNf7WQI9ieKq2gUaXba git.cmu.dev from zenbook"
  ];

  hosts = {
    mimosa = {
      system = "aarch64-linux";
      address = "172.24.97.221";
      mon = true;
      mgr = true;
      # osd id -> bluestore device
      osds = {
        "0" = "/dev/disk/by-id/ata-SAMSUNG_MZ7LH960HAJR-00005_S45NNC0NB40981";
      };
    };
  };
}
