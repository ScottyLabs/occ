FGA_API_TOKEN=$(cat "$OPENFGA_KEY_FILE")
export FGA_API_TOKEN
exec fga "$@"
