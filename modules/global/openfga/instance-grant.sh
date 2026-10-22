usage() {
  echo "usage: occ-instance-grant NAME --project TENANT" >&2
  exit 1
}

[ $# = 3 ] && [ "$2" = --project ] || usage
name=$1 tenant=$3

# fails before granting anything if the instance doesn't exist
incus query "/1.0/instances/$name?project=$tenant" >/dev/null

for relation in can_update_state can_manage_snapshots can_manage_backups; do
  fga tuple write --on-duplicate ignore "group:$tenant#member" "$relation" "instance:$tenant/$name"
done
