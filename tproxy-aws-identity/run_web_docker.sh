# Enable exit on non 0
set -e

CONTAINER_NAME=httpbin

. clean_web_docker.sh

docker run -d -p 80:80 --name ${CONTAINER_NAME} kennethreitz/httpbin