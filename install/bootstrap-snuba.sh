echo "${_group}Bootstrapping and migrating Snuba ..."
set -x

docker ps -a
          docker compose ps
          docker compose logs --names --timestamps || :
          docker logs sentry-self-hosted-clickhouse-1 || :
if [[ -z "${SKIP_SNUBA_MIGRATIONS:-}" ]]; then
  $dcr snuba-api bootstrap --force --log-level debug
else
  echo "Skipped DB migrations due to SKIP_SNUBA_MIGRATIONS=$SKIP_SNUBA_MIGRATIONS"
fi

docker ps -a
          docker compose ps
          docker compose logs --names --timestamps || :
          docker logs sentry-self-hosted-clickhouse-1 || :

echo "${_endgroup}"
