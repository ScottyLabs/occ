# Add an OSD

Run these on the host that has the disk, as root. The host needs a running Ceph cluster and the `client.bootstrap-osd` keyring at `/var/lib/ceph/bootstrap-osd/ceph.keyring`.

1. Find the disk's stable path in `/dev/disk/by-id/`. Use that path, not `/dev/sdX`, everywhere below.

1. If the disk has ever held anything, wipe it. This destroys everything on the disk:

   ```sh
   ceph-volume lvm zap --destroy /dev/disk/by-id/<disk>
   ```

1. Create the OSD. Ceph assigns it the next free ID:

   ```sh
   ceph-volume lvm prepare --data /dev/disk/by-id/<disk>
   ```

1. Look up the new OSD's ID and fsid:

   ```sh
   ceph-volume lvm list /dev/disk/by-id/<disk>
   ```

1. `prepare` leaves the OSD's directory mounted as a tmpfs. Unmount it, then activate the OSD onto the OS disk:

   ```sh
   umount /var/lib/ceph/osd/ceph-<id>
   ceph-volume lvm activate --no-tmpfs --no-systemd <id> <fsid>
   ```

1. Add the ID to the host's `osds` in `cluster.nix` and deploy:

   ```sh
   nixos-rebuild switch --flake .#<host> --target-host root@<host>.lan.cmu.edu --build-host root@<host>.lan.cmu.edu
   ```

1. Check that `systemctl status ceph-osd-<id>` shows it running and that `ceph osd tree` lists it as `up`.
