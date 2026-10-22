# Add a tenant

Run these as root on any host. Each tenant gets a project and an OpenFGA group of the same name, and its members are the Andrew IDs in that group.

1. Create the tenant's project with its limits. It uses the default project's profiles and images, which give its instances their NICs and root disk:

   ```sh
   incus project create <tenant> -c features.profiles=false -c features.images=false \
     -c limits.cpu=<cpus> -c limits.memory=<memory> -c limits.disk=<disk>
   ```

1. Add each member to the tenant's group:

   ```sh
   fga tuple write user:<andrewid>@andrew.cmu.edu member group:<tenant>
   ```

1. Give the group the `user` role on the project:

   ```sh
   fga tuple write "group:<tenant>#member" user project:<tenant>
   ```

1. Check that a member can see the project:

   ```sh
   fga query check user:<andrewid>@andrew.cmu.edu can_view project:<tenant>
   ```

   This prints `"allowed":true`.

To remove a member, run `fga tuple delete` with the same arguments as in step 2. To change a limit, run `incus project set <tenant> limits.<resource>=<value>`.
