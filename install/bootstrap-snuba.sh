echo "${_group}Bootstrapping and migrating Snuba ..."
set -x

docker ps -a
          docker compose ps
          docker compose logs --names --timestamps
if [[ -z "${SKIP_SNUBA_MIGRATIONS:-}" ]]; then
  $dcr snuba-api bootstrap --force
else
  echo "Skipped DB migrations due to SKIP_SNUBA_MIGRATIONS=$SKIP_SNUBA_MIGRATIONS"
fi

docker ps -a
          docker compose ps
          docker compose logs --names --timestamps

echo "${_endgroup}"
