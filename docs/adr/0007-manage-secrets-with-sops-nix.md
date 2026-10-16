# 7. Manage secrets with sops-nix

Date: 2026-10-16

## Status

Accepted

## Context

Every Incus host needs a Ceph client keyring, OSD hosts need the `bootstrap-osd` key, and monitors need the `mon.` key.

sops-nix and agenix both store age-encrypted secrets in the repo and decrypt them on each host at activation. Unlike agenix, sops-nix can restart the units that use a secret when the secret changes, and it has an option for loading age plugins such as `age-plugin-tpm`.

## Decision

We'll manage secrets with sops-nix.

## Consequences

Ceph's keys are generated once and kept encrypted in the repo, so reinstalling a host doesn't change them, and a new host gets them when it's deployed.
