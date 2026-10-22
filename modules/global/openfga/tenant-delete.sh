usage() {
  echo "usage: occ-tenant-delete TENANT" >&2
  exit 1
}

[ $# = 1 ] || usage
tenant=$1

# instances are deleted by hand first
if [ -n "$(incus list --project "$tenant" --format csv --columns n)" ]; then
  echo "$tenant still has instances" >&2
  exit 1
fi

incus project delete "$tenant"

# fga picks the file format from its extension
tuples=$(mktemp --suffix=.json)
trap 'rm -f "$tuples"' EXIT

# project:TENANT also holds the server tuple incus leaves behind for projects without their own profiles
{
  fga tuple read --object "group:$tenant"
  fga tuple read --object "project:$tenant"
  fga tuple read --user "group:$tenant#member" --object instance:
} </dev/null | jq -s '[.[].tuples[].key]' >"$tuples"

fga tuple delete --file "$tuples"
