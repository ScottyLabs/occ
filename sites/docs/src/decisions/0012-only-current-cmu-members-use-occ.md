# 12. Only current CMU members use OCC

Date: 2026-10-17

## Status

Accepted

## Context

CMU deactivates a person's Andrew ID when they leave CMU, and getonline requires an active Andrew ID to register a device. Letting alumni keep access would require accounts that don't depend on CMU, which neither CMU's identity provider (Entra) nor ScottyLabs' Keycloak provides.

## Decision

Only people with an active Andrew ID will have access to OCC.

## Consequences

Members who are leaving CMU need to move anything they want to keep off OCC before their Andrew ID is deactivated.

Instances owned by someone who has left keep running until an admin deletes them.
