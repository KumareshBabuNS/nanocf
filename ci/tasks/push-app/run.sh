#!/bin/bash

set -ex

domain=local.nanocf.io

resolvconf=$(cat /etc/resolv.conf)
rm -f /etc/resolv.conf
echo "$resolvconf" > /etc/resolv.conf

DOCKER_RUN_BLOCKS=false /var/micropcf/docker-run "$domain"

cf api "api.$domain" --skip-ssl-validation
cf auth admin admin
cf target -o micropcf-org -s micropcf-space
cf push app -o cloudfoundry/lattice-app -m 32M

curl -v "http://app.${domain}"
