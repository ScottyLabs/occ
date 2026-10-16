# Register a host and get a public IP

## Register the host

1. On the host, find the wired interface's MAC address with `ip link show <interface>`.
2. Go to [getonline.cmu.edu](https://getonline.cmu.edu) and open "Manage your Network Registrations".
3. Click "register new devices", which opens "Connect to the Wired Network".
4. Fill in the form and submit it:
    - Building: University Center
    - Hostname: the host's name
    - Hardware address: the MAC from step 1
    - Ownership: "This is a departmental device, and should not be associated with my account"
    - Group: scottylabs
5. The host now shows up under "Manage your Network Registrations". DHCP gives it a private address, and its name is `<host>.lan.local.cmu.edu`.

## Request a public IP

Email it-help@cmu.edu, cc ops@scottylabs.org, with the MAC and hostname from the registration:

```
Hi,

ScottyLabs has a device registered with MAC address <mac> and hostname <host>.lan.local.cmu.edu. We're hoping to put a public-facing service on this host. Can we have a public IP for it?

Thanks,
<name>
```

## Switch the host to the public IP

`networkctl renew` keeps the old lease, so drop it with `networkctl reconfigure`. This cuts your SSH session, so schedule it with `systemd-run` and reconnect at the host's new name, `<host>.lan.cmu.edu`:

```sh
systemd-run --on-active=2 networkctl reconfigure <interface>
ssh root@<host>.lan.cmu.edu
```

Check that `ip -4 -br addr show <interface>` and `curl -4 https://ifconfig.me` both show the public IP.

Then set the host's `address` in `cluster.nix` to the public IP. If the host runs a Ceph monitor, do all of this before bootstrapping it, since the monitor's address is fixed in the monitor map.
