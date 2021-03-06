# Enable exit on non 0
set -e

. clean_envoy_docker.sh

if [ -z "${ENVOY_PORT}" ]; then
  PORT=4999
else
  PORT="${ENVOY_PORT}"
fi

if [ -z "${ENVOY_ADMIN_PORT}" ]; then
  ADMIN_PORT=19000
else
  ADMIN_PORT="${ENVOY_ADMIN_PORT}"
fi

CONTAINER_NAME=envoy-tproxy
DOCKERFILE=envoy.Dockerfile

docker build -f ${DOCKERFILE} -t ${CONTAINER_NAME} .
docker run -d --cap-add=NET_ADMIN --network host -p "${PORT}":"${PORT}" -p "${ADMIN_PORT}":"${ADMIN_PORT}" --name ${CONTAINER_NAME} ${CONTAINER_NAME}