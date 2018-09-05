#!/bin/bash -e

# Note: $LOCAL can be something else for several sites running from the console
# eg. LOCAL=site1 ./drupal8_local.sh

LOCAL=${LOCAL:-"local"}

mkdir -p ${LOCAL}/web ${LOCAL}/data

# Create a random ${LOCAL} ssh port for the container
export WEBPORT="8080"
export DBPORT="3336"

echo "**** Starting Drupal using persistence on ${LOCAL}/ folder ****"
echo "     Using MYSQL PORT: ${DBPORT}"
echo "     Using HTTP  URL : http://localhost:${WEBPORT}"

# Create a network
docker network create --subnet=10.8.8.0/16 drupalnet 2>/dev/null || true

# Run the container
docker run -it \
  --net drupalnet \
  --volume=${PWD}/${LOCAL}/data:/var/lib/mysql \
  --volume=${PWD}/${LOCAL}:/var/www/html \
  -p ${WEBPORT}:80 \
  -p ${DBPORT}:3306 \
  ricardoamaro/drupal8