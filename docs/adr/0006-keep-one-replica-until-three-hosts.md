# 6. Keep one replica until three hosts have OSDs

Date: 2026-10-13

## Status

Accepted

## Context

Ceph pools default to `size=3` and `min_size=2`. A placement group with fewer than `min_size` copies stops serving I/O, so with one OSD no I/O is possible under the defaults. Setting `size=1` requires `mon_allow_pool_size_one`.

## Decision

We'll set `mon_allow_pool_size_one` and run pools at `size=1`, `min_size=1` until three hosts have OSDs. At that point we move them to `size=3`, `min_size=2`, with each copy on a different host.

## Consequences

We can switch to `size=3` later without downtime.
