# Create an instance

Run these as root on any host, which uses Incus's local socket.

1. Create the instance in its tenant's project without starting it. The project's limits require every instance to set its CPUs, memory, and disk size. VMs need an image with cloud-init, such as `images:debian/13/cloud`:

   ```sh
   incus init <image> <name> --project <tenant> [--vm] [--target <host>] \
     -c limits.cpu=<cpus> -c limits.memory=<memory> -d root,size=<disk>
   ```

1. Give it its IPv6 address, which the command prints:

   ```sh
   occ-instance-ipv6 <name> --project <tenant>
   ```

1. Start it:

   ```sh
   incus start <name> --project <tenant>
   ```

1. Let the tenant start, stop, snapshot, and back up the instance:

   ```sh
   occ-instance-grant <name> --project <tenant>
   ```

1. Send the tenant the instance's MAC, which one of its members registers in getonline:

   ```sh
   incus config get <name> volatile.eth0.hwaddr --project <tenant>
   ```

To move an instance to another host, stop it, move it, give it the new host's address, and start it again:

```sh
incus stop <name> --project <tenant>
incus move <name> --target <host> --project <tenant>
occ-instance-ipv6 <name> --project <tenant>
incus start <name> --project <tenant>
```
