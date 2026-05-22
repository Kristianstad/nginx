# =========================================================================
# Init
# =========================================================================
# ARGs (can be passed to Build/Final) <BEGIN>
ARG SaM_REPO=${SaM_REPO:-ghcr.io/kristianstad/secure_and_minimal}
ARG ALPINE_VERSION=${ALPINE_VERSION:-3.23}
ARG APP_VERSION=${APP_VERSION:-1.28.3}
ARG IMAGETYPE="application"
ARG RUNDEPS="nginx nginx-mod-http-brotli"
ARG MAKEDIRS="/var/log/nginx /usr/lib/nginx/modules /run/nginx /etc/nginx/http.d /var/lib/nginx/tmp"
ARG FINALCMDS=\
"   sed -i '/worker_processes auto/d;/user nginx/d' /etc/nginx/nginx.conf "\
"&& find /var -user 185 -exec chown 0:0 {} \;"
ARG REMOVEFILES="/etc/nginx/http.d/default.conf"
ARG LINUXUSEROWNED="/var/log/nginx /usr/lib/nginx/modules /run/nginx /var/lib/nginx/tmp"
ARG STARTUPEXECUTABLES="/usr/sbin/nginx"
# ARGs (can be passed to Build/Final) </END>

# Generic template (don't edit) <BEGIN>
FROM ${CONTENTIMAGE1:-scratch} AS content1
FROM ${CONTENTIMAGE2:-scratch} AS content2
FROM ${CONTENTIMAGE3:-scratch} AS content3
FROM ${CONTENTIMAGE4:-scratch} AS content4
FROM ${CONTENTIMAGE5:-scratch} AS content5
FROM ${BASEIMAGE:-$SaM_REPO:base-${ALPINE_VERSION}} AS base
FROM ${INITIMAGE:-scratch} AS init
# Generic template (don't edit) </END>

# =========================================================================
# Build
# =========================================================================
# Generic template (don't edit) <BEGIN>
FROM ${BUILDIMAGE:-$SaM_REPO:build-${ALPINE_VERSION}} AS build
FROM ${BASEIMAGE:-$SaM_REPO:base-${ALPINE_VERSION}} AS final
COPY --from=build /finalfs /
# Generic template (don't edit) </END>

# =========================================================================
# Final
# =========================================================================
# Re-declare ARGs
ARG ALPINE_VERSION
ARG APP_VERSION

ENV VAR_CONFIG_DIR="/etc/nginx" \
    VAR_LINUX_USER="nginx" \
    VAR_LOG_LEVEL="info" \
    VAR_WORKER_PROCESSES="auto" \
    VAR_WORKER_RLIMIT_NOFILE="2048" \
    VAR_FINAL_COMMAND="nginx -g 'daemon off; user \$VAR_LINUX_USER; error_log stderr \$VAR_LOG_LEVEL; worker_processes \$VAR_WORKER_PROCESSES; worker_rlimit_nofile \$VAR_WORKER_RLIMIT_NOFILE;'" \
    VAR_server01_listen="8080 default_server" \
    VAR_server02_listen="[::]:8080 default_server" \
    VAR_server03_access_log="off" \
    VAR_server04_client_max_body_size="0" \
    VAR_server05_client_body_buffer_size="128k" \
    VAR_server06_sendfile="on" \
    VAR_server07_sendfile_max_chunk="1m" \
    VAR_server08_tcp_nopush="on" \
    VAR_server09_tcp_nodelay="on" \
    VAR_server10_gzip="on" \
    VAR_server11_gzip_vary="on" \
    VAR_server12_gzip_min_length="1000" \
    VAR_server13_gzip_proxied="any" \
    VAR_server14_gzip_types="text/plain text/css text/xml text/javascript application/javascript application/x-javascript application/xml application/json application/xml+rss" \
    VAR_server15_root="/www" \
    VAR_server16_index="index.html" \
    VAR_server17_brotli="off" \
    VAR_server18_brotli_static="on" \
    VAR_server19_gzip_static="on" \
    VAR_serversub01_location="/ {  }"

# Generic template (don't edit) <BEGIN>
USER starter
ONBUILD USER root
# Generic template (don't edit) </END>

LABEL org.opencontainers.image.version="${APP_VERSION}" \
      org.opencontainers.image.title="nginx" \
      org.opencontainers.image.description="Nginx ${APP_VERSION} with brotli support based on secure_and_minimal ${ALPINE_VERSION}"
