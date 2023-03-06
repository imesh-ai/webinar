#!/bin/sh
set -e

echo "Generating envoy-demo.yaml config file..."
cat /template/envoy-demo.yaml.template | envsubst \$ENVOY_LB_POLICY,\$SERVICE_NAME,\$SERVICE_PORT > /etc/envoy-demo.yaml

echo "Starting Envoy with config /etc/envoy-demo.yaml..."
/usr/local/bin/envoy -c /etc/envoy-demo.yaml
