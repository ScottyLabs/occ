# Deploy a host

From the repo root, run:

```sh
nixos-rebuild switch --flake .#<host> --target-host root@<host>.lan.cmu.edu --build-host root@<host>.lan.cmu.edu
```

The build runs on the host itself, since hosts can have a different CPU architecture from your machine.

To try a change without making it the boot default, run `test` instead of `switch`. Rebooting the host then returns it to the configuration it had before.

After adding a host to `cluster.nix`, deploy every existing host as well, since each host's firewall only accepts Incus, Ceph, and WireGuard traffic from the hosts listed there.
