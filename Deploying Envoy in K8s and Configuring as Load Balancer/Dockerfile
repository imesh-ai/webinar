FROM envoyproxy/envoy:v1.25-latest
COPY envoy-demo.yaml /template/envoy-demo.yaml.template

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

RUN apt-get update && apt-get install gettext -y

ENTRYPOINT ["/docker-entrypoint.sh"]
