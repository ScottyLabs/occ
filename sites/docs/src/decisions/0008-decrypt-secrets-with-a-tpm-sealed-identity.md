# 8. Decrypt secrets with a TPM-sealed identity

Date: 2026-10-16

## Status

Accepted

## Context

sops-nix decrypts with the host's ed25519 SSH host key by default, and since that key sits unencrypted on the OS disk, anyone holding the disk can decrypt every secret encrypted to the host.

`age-plugin-tpm` generates age identities whose keys are sealed by a TPM, so they can't be used on any other machine. Every host currently has a discrete TPM.

## Decision

Each host will decrypt its secrets with an `age-plugin-tpm` identity, and secrets will be encrypted to those identities instead of to SSH host keys.

## Consequences

A host's identity is generated on the host itself, and its recipient has to be added to the repo before the host can decrypt anything.

Firmware updates don't affect decryption, since `age-plugin-tpm` doesn't bind keys to PCRs.
