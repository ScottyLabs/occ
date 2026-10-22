# Runbooks

| Runbook | Covers |
|---|---|
| [Deploy a host](deploy-a-host.md) | deploying a host's configuration from this repo |
| [Register a host and get a public IP](register-a-host.md) | CMU getonline registration, the public IP request, and switching the host to the new address |
| [Add an OSD](add-an-osd.md) | creating an OSD on a blank disk in ceph-volume's `lvm` mode and declaring it in `cluster.nix` |
| [Set up a host's TPM identity](set-up-a-host-tpm-identity.md) | generating a host's `age-plugin-tpm` identity and adding it as a sops recipient |
| [Add an admin](add-an-admin.md) | generating an admin's post-quantum age key and adding it and their SSH key to the repo |
| [Add a tenant](add-a-tenant.md) | creating a tenant's project with its limits and giving its members access |
| [Delete a tenant](delete-a-tenant.md) | deleting a tenant's instances, project, and its members' access |
| [Create an instance](create-an-instance.md) | creating an instance in a tenant's project with its IPv6 address, and moving it to another host |
| [Connect to Incus](connect-to-incus.md) | adding the cluster as an `incus` remote and signing in with your Andrew ID |
