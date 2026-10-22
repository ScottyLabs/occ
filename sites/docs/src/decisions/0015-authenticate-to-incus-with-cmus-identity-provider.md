# 15. Authenticate to Incus with CMU's identity provider

Date: 2026-10-17

## Status

Accepted

## Context

Incus authenticates users either with TLS client certificates, which an admin trusts one at a time and can restrict to projects, or with OIDC as a public client, using the device authorization flow for the `incus` CLI.

## Decision

Incus will authenticate users with OIDC directly against CMU's identity provider, registered as a relying party through Computing Services.

## Consequences

A deactivated Andrew ID can no longer log in, without any action from us.

Logins go through CMU's two-factor authentication.
