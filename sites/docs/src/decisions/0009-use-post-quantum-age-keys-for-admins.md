# 9. Use post-quantum age keys for admins

Date: 2026-10-16

## Status

Accepted

## Context

Encrypted secrets recorded today could be decrypted later by a quantum computer if every key they're encrypted to is classic. age 1.3 and sops 3.12 support hybrid ML-KEM-768 + X25519 keys (`age1pq1`) without `age-plugin-pq`.

Host identities from `age-plugin-tpm` are classic P-256 keys because TPMs can't run ML-KEM, but sops can still encrypt a file to them alongside post-quantum keys, since it encrypts the data key to each recipient separately.

## Decision

Admins will use post-quantum age keys.

## Consequences

Only secrets that no host needs get post-quantum protection, because anything a host can decrypt is also encrypted to its P-256 TPM identity.
