# 2. Use Incus to run instances

Date: 2026-10-13

## Status

Accepted

## Context

The alternative was managing instances through pull requests. A generator would turn each request into Terraform for libvirt and commit it, and CI would apply it. Every instance would be reviewed and recorded in git, but:

- libvirt manages one host at a time, so we'd write host placement, quotas, and per-owner access.
- Owners would still need a way to reboot an instance or open a console without a PR.
- CI would need credentials for every hypervisor.
- Terraform state would need a home outside the repo, with locking.
- Anything changed outside of Terraform would drift from what's in git.

Incus supports VMs and system containers, clustering several hosts behind one API, placing instances across hosts, Ceph-backed disks, per-project resource limits and access control, and a web UI. An Incus Terraform provider exists, so a PR workflow could be built on top of it later.

## Decision

We'll run all VMs and containers with Incus, with every host in one Incus cluster.

## Consequences

Which instances exist is recorded in Incus's database rather than the repo, so changes made through the API or UI don't show up in git.

We still need to decide how owners authenticate to Incus and how projects map to people.
