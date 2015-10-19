set -e

if [[ -z "$SENSU_API_PORT_4567_TCP_ADDR" ]]; then
  echo '$SENSU_API_PORT_4567_TCP_ADDR not defined. Aborting...' >&2
  exit 1
fi

if [[ -z "$SENSU_API_ENV_API_USER" ]]; then
  echo '$SENSU_API_ENV_API_USER not defined. Aborting...' >&2
  exit 1
fi

if [[ -z "$SENSU_API_ENV_API_PASSWORD" ]]; then
  echo '$SENSU_API_ENV_API_PASSWORD not defined. Aborting...' >&2
  exit 1
fi

template='/docker-templates/config.tmpl.json'
config='/etc/uchiwa/config.json'

install -DZm 0600 "$template" "$config"

if [[ -z "$PORT" ]]; then
  PORT=3000
fi

if [[ -z "$REFRESH" ]]; then
  REFRESH=5
fi

function escape_sed {
  echo "$1" | sed -r 's/\//\\\//g'
}

sed -i.tmp 's/{{\s*PORT\s*}}/'"$(escape_sed "$PORT")"'/g' \
  "$config"

sed -i.tmp 's/{{\s*REFRESH\s*}}/'"$(escape_sed "$REFRESH")"'/g' \
  "$config"

sed -i.tmp 's/{{\s*SENSU_API_PORT_4567_TCP_ADDR\s*}}/'"$(escape_sed "$SENSU_API_PORT_4567_TCP_ADDR")"'/g' \
  "$config"

sed -i.tmp 's/{{\s*SENSU_API_ENV_API_USER\s*}}/'"$(escape_sed "$SENSU_API_ENV_API_USER")"'/g' \
  "$config"

sed -i.tmp 's/{{\s*SENSU_API_ENV_API_PASSWORD\s*}}/'"$(escape_sed "$SENSU_API_ENV_API_PASSWORD")"'/g' \
  "$config"

rm -vf "${config}.tmp"

exec uchiwa \
  -c "$config" \
  "$@"
