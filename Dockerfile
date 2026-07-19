ARG GROK2API_BASE_IMAGE=ghcr.io/chenyme/grok2api:v3.0.4
FROM ${GROK2API_BASE_IMAGE}

COPY docker-entrypoint-wrapper.sh /usr/local/bin/grok2api-zeabur-entrypoint
RUN chmod 0755 /usr/local/bin/grok2api-zeabur-entrypoint

VOLUME ["/app/data"]

ENTRYPOINT ["/usr/local/bin/grok2api-zeabur-entrypoint"]
CMD ["/app/grok2api", "--config", "/app/config.yaml", "--listen", "0.0.0.0:8000"]
