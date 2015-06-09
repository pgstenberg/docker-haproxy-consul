#!/bin/sh

echo "Setting up proxy agains consul-url ${CONSUL_URL}."
echo "Binding configuration with ${CONSUL_CONFIG_BINDING}"

echo "Generating initial HAProxy configuration..."
consul-template -consul ${CONSUL_URL} -template ${CONSUL_CONFIG_BINDING} -once

echo "Starting HAProxy..."
haproxy -f /usr/local/etc/haproxy/haproxy.cfg -p /var/run/haproxy.pid -D

echo "Binding gracefully restart for HAProxy..."
consul-template -consul ${CONSUL_URL} -template ${CONSUL_CONFIG_BINDING} -dry
