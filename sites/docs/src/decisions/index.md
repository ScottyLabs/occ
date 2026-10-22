# Architecture decisions

| # | Decision | Status |
|---|---|---|
| 1 | [Record architecture decisions](0001-record-architecture-decisions.md) | accepted |
| 2 | [Use Incus to run instances](0002-use-incus-to-run-instances.md) | accepted |
| 3 | [Store instance disks in Ceph](0003-store-instance-disks-in-ceph.md) | accepted |
| 4 | [Create OSDs in ceph-volume's lvm mode](0004-create-osds-in-ceph-volume-lvm-mode.md) | accepted |
| 5 | [Use sdd as the OSD on mimosa](0005-use-sdd-as-the-osd-on-mimosa.md) | accepted |
| 6 | [Keep one replica until three hosts have OSDs](0006-keep-one-replica-until-three-hosts.md) | accepted |
| 7 | [Manage secrets with sops-nix](0007-manage-secrets-with-sops-nix.md) | accepted |
| 8 | [Decrypt secrets with a TPM-sealed identity](0008-decrypt-secrets-with-a-tpm-sealed-identity.md) | accepted |
| 9 | [Use post-quantum age keys for admins](0009-use-post-quantum-age-keys-for-admins.md) | accepted |
| 10 | [Only admins create and edit instances](0010-only-admins-create-and-edit-instances.md) | accepted |
| 11 | [Give every instance a bridged IPv4 NIC and a routed IPv6 NIC](0011-give-every-instance-a-bridged-ipv4-nic-and-a-routed-ipv6-nic.md) | accepted |
| 12 | [Only current CMU members use OCC](0012-only-current-cmu-members-use-occ.md) | accepted |
| 13 | [Get Incus's certificate through Cloudflare DNS](0013-get-the-incus-certificate-through-cloudflare-dns.md) | accepted |
| 14 | [Authorize Incus requests with OpenFGA](0014-authorize-incus-requests-with-openfga.md) | accepted |
| 15 | [Authenticate to Incus with CMU's identity provider](0015-authenticate-to-incus-with-cmus-identity-provider.md) | accepted |
| 16 | [Give each tenant their own Incus project](0016-give-each-tenant-their-own-incus-project.md) | accepted |
