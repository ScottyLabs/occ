# 13. Get Incus's certificate through Cloudflare DNS

Date: 2026-10-17

## Status

Accepted

## Context

Incus can request a certificate from an ACME CA such as Let's Encrypt and renew it on its own. The CA checks that we control the domain either by fetching a file from the host on port 80 or by looking up a DNS record that Incus creates through the DNS provider's API.

The DNS for `occ.build` is hosted on Cloudflare.

## Decision

Incus will get its certificate from Let's Encrypt, proving control of its domain with DNS records it creates through Cloudflare's API. It will use a Cloudflare token that can only edit DNS records in `occ.build`, and an ACME account with admin@scottylabs.org as its contact.

## Consequences

Hosts don't need to accept connections on port 80.
