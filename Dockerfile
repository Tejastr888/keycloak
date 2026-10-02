FROM quay.io/keycloak/keycloak:26.0 AS builder
ENV KC_DB=postgres
ENV KC_CACHE=local
RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:26.0
COPY --from=builder /opt/keycloak/ /opt/keycloak/
ENV KC_HTTP_ENABLED=true \
    KC_HTTP_PORT=10000 \
    KC_PROXY_HEADERS=xforwarded \
    KC_HOSTNAME_STRICT=false \
    JAVA_OPTS_KC_HEAP="-XX:MaxRAMPercentage=65"
ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
CMD ["start", "--optimized"]
