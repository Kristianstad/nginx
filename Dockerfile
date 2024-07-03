# =========================================================================
# Init
# =========================================================================
# ARGs (can be passed to Build/Final) <BEGIN>
ARG SaM_REPO=${SaM_REPO:-ghcr.io/kristianstad/secure_and_minimal}
ARG ALPINE_VERSION=${ALPINE_VERSION:-3.20}
ARG IMAGETYPE="application"
ARG RUNDEPS="nginx"
ARG MAKEDIRS="/var/log/nginx /usr/lib/nginx/modules /var/lib/nginx/tmp /run/nginx /etc/nginx/http.d"
ARG FINALCMDS=\
"   sed -i '/worker_processes auto/d;/user nginx/d' /etc/nginx/nginx.conf "\
"&& find /var -user 185 -exec chown 0:0 {} \;"
ARG REMOVEFILES="/etc/nginx/http.d/default.conf"
ARG LINUXUSEROWNED="/var/log/nginx /usr/lib/nginx/modules /var/lib/nginx/tmp /run/nginx"
ARG STARTUPEXECUTABLES="/usr/sbin/nginx"
# ARGs (can be passed to Build/Final) </END>

# Generic template (don't edit) <BEGIN>
FROM ${CONTENTIMAGE1:-scratch} as content1
FROM ${CONTENTIMAGE2:-scratch} as content2
FROM ${CONTENTIMAGE3:-scratch} as content3
FROM ${CONTENTIMAGE4:-scratch} as content4
FROM ${CONTENTIMAGE5:-scratch} as content5
FROM ${BASEIMAGE:-$SaM_REPO:base-$ALPINE_VERSION} as base
FROM ${INITIMAGE:-scratch} as init
# Generic template (don't edit) </END>

# =========================================================================
# Build
# =========================================================================
# Generic template (don't edit) <BEGIN>
FROM ${BUILDIMAGE:-$SaM_REPO:build-$ALPINE_VERSION} as build
FROM ${BASEIMAGE:-$SaM_REPO:base-$ALPINE_VERSION} as final
COPY --from=build /finalfs /
# Generic template (don't edit) </END>

# =========================================================================
# Final
# =========================================================================
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
    VAR_server05_sendfile="on" \
    VAR_server06_sendfile_max_chunk="1m" \
    VAR_server07_tcp_nopush="on" \
    VAR_server08_tcp_nodelay="on" \
    VAR_server09_gzip="on" \
    VAR_server10_gzip_vary="off" \
    VAR_server11_gzip_min_length="10240" \
    VAR_server12_gzip_proxied="any" \
    VAR_server13_gzip_types="text/plain text/css text/xml text/javascript application/javascript application/x-javascript application/xml application/json" \
    VAR_server14_root="/www" \
    VAR_server15_index="index.html" \
    VAR_serversub01_location="/ {  }"

# Generic template (don't edit) <BEGIN>
USER starter
ONBUILD USER root
# Generic template (don't edit) </END>
