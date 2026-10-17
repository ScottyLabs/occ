# 10. Only admins create and edit instances

Date: 2026-10-17

## Status

Accepted

## Context

In Incus, permission to create or edit an instance covers all of its config, including the MAC and IP addresses of its NICs. A tenant with that permission could give their instance addresses that belong to another tenant's instance.

We want admins to decide each instance's CPU, memory, and disk.

## Decision

Admins will create instances and change their config, while tenants get Incus's `user` role on their own instances, plus permission to start and stop them and to manage their snapshots and backups.

## Consequences

Tenants ask admins to create, resize, or reconfigure an instance.

No tenant can set another instance's MAC or IPv6 address through Incus.

Tenants can take and delete snapshots, but can't restore a snapshot, reinstall an instance from an image, boot it from an ISO, or delete or rename it, since Incus requires `can_edit` for each of those.
