# 16. Give each tenant their own Incus project

Date: 2026-10-17

## Status

Accepted

## Context

An Incus project groups instances and can cap their combined CPU, memory, and disk. In OpenFGA, a user's role on a project carries down to every instance in it, and the project's `operator` role includes permission to create instances and edit any instance in the project.

## Decision

Each tenant will get their own Incus project, with limits on its total resources. Tenants get the `user` role on their project, and admins grant them permission to start, stop, snapshot, and back up each instance when they create it.

## Consequences

A tenant's console, command, and file access covers every instance in their project.

Admins decide how much CPU, memory, and disk each tenant can use in total.
