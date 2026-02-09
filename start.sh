#!/bin/bash
set -e
PORT="${PORT:-8080}"
export CATALINA_OPTS="-Dport.http=${PORT}"
# Tomcat 9 uses Connector port in server.xml - replace 8080 with $PORT
sed -i "s/port=\"8080\"/port=\"${PORT}\"/" "$CATALINA_HOME/conf/server.xml"
exec catalina.sh run
