echo "${_group}Creating volumes for persistent storage ..."
set -x
create_volume() {
  local name=$1
  declare -a create_command=("$CONTAINER_ENGINE" volume create)
  if [ "$CONTAINER_ENGINE" = "podman" ]; then
    create_command+=(--ignore "$name")
  else
    create_command+=("--name=$name")
  fi

  "${create_command[@]}"
}

echo "Created $(create_volume sentry-clickhouse)."
echo "Created $(create_volume sentry-data)."
echo "Created $(create_volume sentry-kafka)."
echo "Created $(create_volume sentry-postgres)."
echo "Created $(create_volume sentry-redis)."
echo "Created $(create_volume sentry-symbolicator)."

echo "${_endgroup}"
