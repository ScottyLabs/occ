# Delete a tenant

Run these as root on any host.

1. Delete each of the tenant's instances, which destroys their data:

   ```sh
   incus list --project <tenant>
   incus delete -f <name> --project <tenant>
   ```

1. Delete the tenant's project and its members' access:

   ```sh
   occ-tenant-delete <tenant>
   ```

1. Check that `incus project list` no longer lists the tenant.
