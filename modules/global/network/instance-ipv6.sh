usage() {
  echo "usage: occ-instance-ipv6 NAME [--project PROJECT]" >&2
  exit 1
}

case $# in
  1) name=$1 project=default ;;
  3) [ "$2" = --project ] || usage; name=$1 project=$3 ;;
  *) usage ;;
esac

in_project() { incus "$@" --project "$project"; }

instance=$(incus query "/1.0/instances/$name?project=$project")
host=$(jq -r .location <<<"$instance")
type=$(jq -r .type <<<"$instance")
prefix=$(jq -er --arg host "$host" '.[$host]' /etc/occ/ipv6-prefixes.json)
mac=$(in_project config get "$name" volatile.eth0.hwaddr)
[ -n "$mac" ] || { echo "$name has no eth0 MAC" >&2; exit 1; }

address=$(ipv6calc --action prefixmac2ipv6 --in prefix+mac --out ipv6addr "$prefix" "$mac" | cut -d/ -f1)

if in_project config device get "$name" eth1 nictype >/dev/null 2>&1; then
  in_project config device set "$name" eth1 ipv6.address="$address"
else
  in_project config device add "$name" eth1 nic nictype=routed ipv6.address="$address"
fi

# incus only configures routed nics inside containers
if [ "$type" = virtual-machine ]; then
  eth1_mac=$(in_project config get "$name" volatile.eth1.hwaddr)
  network_config=$(cat <<EOF
version: 2
ethernets:
  eth0:
    match:
      macaddress: "$mac"
    dhcp4: true
    accept-ra: false
  eth1:
    match:
      macaddress: "$eth1_mac"
    addresses: ["$address/128"]
    routes:
      - to: "::/0"
        via: "fe80::1"
    accept-ra: false
EOF
)
  in_project config set "$name" cloud-init.network-config="$network_config"
fi

echo "$address"
