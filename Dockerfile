# =========================================================================
# Init
# =========================================================================
# ARGs (can be passed to Build/Final) <BEGIN>
ARG SaM_REPO=${SaM_REPO:-ghcr.io/kristianstad/secure_and_minimal}
ARG ALPINE_VERSION=${ALPINE_VERSION:-3.18}
ARG IMAGETYPE="application"
ARG RUNDEPS="nginx"
ARG MAKEDIRS="/var/log/nginx /usr/lib/nginx/modules /var/lib/nginx/tmp /run/nginx"
ARG FINALCMDS="find /var -user 185 -exec chown 0:0 {} \;"
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
    VAR_FINAL_COMMAND="nginx -g 'daemon off;'" \
    VAR_main1_error_log="stderr info" \
    VAR_main2_worker_rlimit_nofile="2048" \
    VAR_server1_listen="8080 default_server" \
    VAR_server2_listen="[::]:8080 default_server" \
    VAR_server3_access_log="off" \
    VAR_server4_client_max_body_size="0" \
    VAR_server5_sendfile="on" \
    VAR_server6_sendfile_max_chunk="1m" \
    VAR_server7_tcp_nopush="on" \
    VAR_server8_tcp_nodelay="on" \
    VAR_server9_gzip="on" \
    VAR_server10_gzip_vary="off" \
    VAR_server11_gzip_min_length="10240" \
    VAR_server12_gzip_proxied="any" \
    VAR_server13_gzip_types="text/plain text/css text/xml text/javascript application/javascript application/x-javascript application/xml application/json" \
    VAR_server14_root="/www" \
    VAR_server15_index="index.html"

# Generic template (don't edit) <BEGIN>
USER starter
ONBUILD USER root
# Generic template (don't edit) </END>
