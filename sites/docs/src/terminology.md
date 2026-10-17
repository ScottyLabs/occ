# Terminology

| Term | Meaning |
|---|---|
| Host | One of our physical machines, which runs Incus and Ceph. getonline calls any registered device a host, but these docs only use the word for our machines. |
| Instance | A container or VM that Incus runs on a host. |
| Tenant | A person or team that runs instances on the cluster. An instance's owner is the tenant it was created for. |
| Admin | Someone whose SSH and age keys are in `keys/admins`, which lets them deploy hosts and decrypt secrets. |
| Cluster | All of our hosts, which together run one Incus cluster and one Ceph cluster. |
| Tunnel host | The host that Hurricane Electric's IPv6 tunnel ends on, which forwards IPv6 to and from the other hosts. |
| OSD | A Ceph daemon that stores data on one disk. |
| Monitor | A Ceph daemon that holds the cluster map and keys. |
| Manager | A Ceph daemon that runs background tasks like PG autoscaling. |
