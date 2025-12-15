# nginx
https://github.com/Kristianstad/nginx/pkgs/container/nginx

Nginx, running on Alpine. Configuration is set by given VAR-variables. Listens on port 8080 internally by default.

## Environment variables
### Runtime variables with default value
* VAR_LINUX_USER="nginx" (User running VAR_FINAL_COMMAND)
* VAR_CONFIG_DIR="/etc/nginx" (Directory containing configuration files)
* VAR_LOG_LEVEL="info"
* VAR_WORKER_PROCESSES="auto"
* VAR_WORKER_RLIMIT_NOFILE="2048"
* VAR_FINAL_COMMAND="nginx -g 'daemon off; user \$VAR_LINUX_USER; error_log stderr \$VAR_LOG_LEVEL; worker_processes \$VAR_WORKER_PROCESSES; worker_rlimit_nofile \$VAR_WORKER_RLIMIT_NOFILE;'"
* VAR_server01_listen="8080 default_server"
* VAR_server02_listen="[::]:8080 default_server"
* VAR_server03_access_log="off"
* VAR_server04_client_max_body_size="0"
* VAR_server05_client_body_buffer_size="128k"
* VAR_server06_sendfile="on"
* VAR_server07_sendfile_max_chunk="1m"
* VAR_server08_tcp_nopush="on"
* VAR_server09_tcp_nodelay="on"
* VAR_server10_gzip="on"
* VAR_server11_gzip_vary="off"
* VAR_server12_gzip_min_length="10240"
* VAR_server13_gzip_proxied="any"
* VAR_server14_gzip_types="text/plain text/css text/xml text/javascript application/javascript application/x-javascript application/xml application/json application/xml+rss"
* VAR_server15_root="/www"
* VAR_server16_index="index.html"
* VAR_server17_brotli="off"
* VAR_server18_brotli_static="on"
* VAR_server19_gzip_static="on"
* VAR_serversub01_location="/ {  }"

## Capabilities
Can drop all but CHOWN, SETPCAP, SETGID and SETUID.

