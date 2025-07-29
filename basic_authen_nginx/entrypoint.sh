#!/bin/sh
set -e

echo "Update the .htpasswd file with your credentials..."
# variable from ssm
echo $HTPASSWD_INFO > /etc/nginx/.htpasswd
# Start Nginx in the foreground
echo "Nginx is starting..."
exec nginx -g "daemon off;"
