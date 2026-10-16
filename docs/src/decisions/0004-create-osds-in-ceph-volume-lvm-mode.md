# 4. Create OSDs in ceph-volume's lvm mode

Date: 2026-10-16

## Status

Accepted

## Context

ceph-volume can prepare an OSD in `raw` mode, which writes BlueStore directly to the device, or in `lvm` mode, which writes it to a logical volume tagged with the OSD's metadata. In both modes, activation rebuilds the OSD's data directory from the device.

We plan to add an Intel Optane to hold BlueStore's database and write-ahead log for existing OSDs. In `lvm` mode, `ceph-volume lvm new-db` and `ceph-volume lvm migrate` attach and move them onto a logical volume, and the change is recorded in the OSD's tags. ceph-volume has no equivalent for raw OSDs, so the move would have to be done with `ceph-bluestore-tool`, and the new device added to the OSD's activation command by hand.

## Decision

We'll create OSDs in ceph-volume's `lvm` mode.

## Consequences

We'll move OSD databases to the Optane by hand with `ceph-volume lvm new-db` and `ceph-volume lvm migrate`, so the repo won't record where each database lives.
