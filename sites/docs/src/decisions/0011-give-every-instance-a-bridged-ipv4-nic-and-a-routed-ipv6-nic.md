# 11. Give every instance a bridged IPv4 NIC and a routed IPv6 NIC

Date: 2026-10-17

## Status

Accepted

## Context

A device gets a routable address on CMU's network only after its MAC is registered in getonline, and the address is only reachable within CMU unless whoever registered it requests a public one from Computing Services. CMU holds that person responsible for the device.

With a macvlan NIC, nothing on the host can stop an instance from sending as another instance's MAC. A `bridged` NIC on a bridge over the host's uplink also puts the instance on CMU's network with its own MAC, and `security.mac_filtering` drops frames and ARP replies from it that carry any other MAC. Incus doesn't check the client MAC inside DHCP requests, so we rely on CMU's network to check it.

Hurricane Electric routes `2001:470:e2be::/48` to us through a 6in4 tunnel that ends on mimosa. CMU's network doesn't carry IPv6, and Hurricane Electric allows only five tunnels per account, so hosts can't each have their own tunnel.

An Incus-managed bridge would put a host's instances on one network segment and give every host in the cluster the same /64. A `routed` NIC gives an instance its own link to the host and routes only that instance's addresses down it, but Incus doesn't choose those addresses, so admins have to pick one for each NIC. Deriving it from the instance's MAC gives each instance its own address without anyone keeping a list of which addresses are taken.

## Decision

Each host will get its own /64 from the /48, and the host the tunnel ends on will route every other host's /64 to it over WireGuard.

Each instance's IPv4 NIC will be a `bridged` NIC on a bridge over its host's uplink, with MAC filtering enabled and a MAC that the instance's owner registers in getonline themselves. Its IPv6 NIC will be a `routed` NIC whose address is the EUI-64 address of the IPv4 NIC's MAC within the host's /64.

## Consequences

CMU's records name each instance's owner, not the cluster's admins, as responsible for the instance.

An instance has no routable IPv4 until its owner registers its MAC in getonline, and no public IPv4 until its owner also requests one from Computing Services.

Over IPv4, instances share CMU's network segment with each other and with every other device on it. Over IPv6, they reach each other only through their hosts, without seeing each other's link-layer traffic.

The host drops IPv6 traffic an instance sends from any address other than its own, since Incus applies reverse-path filtering to routed NICs.

An instance gets its IPv6 address from admins when they create it, and a new one from its new host's /64 when they move it.

VMs need cloud-init to configure their IPv6 address and gateway, since Incus only configures routed NICs inside containers.

Every instance's IPv6 traffic passes through the host the tunnel ends on, so if that host goes down, every instance loses IPv6.

IPv6 packets to and from instances on other hosts can be at most about 1420 bytes, since WireGuard adds about 60 bytes of its own headers within the tunnel's 1480-byte limit.
