# 5. Use sdd as the OSD on mimosa

Date: 2026-10-13

## Status

Accepted

## Context

mimosa currently has two 960 GB Samsung SSDs: the OS is on `nvme0n1` (PM983), and `sdd` (PM883, SATA) is free.

## Decision

We'll run one OSD on all of `sdd`.

## Consequences

mimosa currently provides 960 GB of raw capacity.
