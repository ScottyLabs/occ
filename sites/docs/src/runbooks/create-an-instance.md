# Create an instance

Run these as root on any host, which uses Incus's local socket.

1. Create the instance without starting it. VMs need an image with cloud-init, such as `images:debian/13/cloud`:

   ```sh
   incus init <image> <name> --project <project> [--vm] [--target <host>]
   ```

1. Give it its IPv6 address, which the command prints:

   ```sh
   occ-instance-ipv6 <name> --project <project>
   ```

1. Start it:

   ```sh
   incus start <name> --project <project>
   ```

1. Send the owner the instance's MAC, which they register in getonline themselves:

   ```sh
   incus config get <name> volatile.eth0.hwaddr --project <project>
   ```

To move an instance to another host, stop it, move it, give it the new host's address, and start it again:

```sh
incus stop <name> --project <project>
incus move <name> --target <host> --project <project>
occ-instance-ipv6 <name> --project <project>
incus start <name> --project <project>
```
