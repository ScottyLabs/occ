# 14. Authorize Incus requests with OpenFGA

Date: 2026-10-17

## Status

Accepted

## Context

Incus can authorize OIDC users with OpenFGA, a separate server it queries on every request, or with a scriptlet stored in its own config. OpenFGA supports permissions on individual instances that change at runtime, while a scriptlet keeps every rule and membership in a script stored in Incus's config.

OpenFGA stores all of its data in PostgreSQL or MySQL, and it can send reads to a replica of a PostgreSQL database. nixpkgs packages OpenFGA and has a NixOS module for it.

## Decision

We'll run OpenFGA on every host, with PostgreSQL as its datastore, and Incus on each host will use the OpenFGA on that host to authorize requests.

## Consequences

Admins grant and revoke access through OpenFGA's API, so memberships aren't recorded in git.

If OpenFGA is down, OIDC users can't use Incus, though admins can still use the local socket on a host.
