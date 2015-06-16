#!/bin/sh

echo "Setting up proxy agains consul-url ${CONSUL_URL}."
echo "Binding configuration with ${CONSUL_CONFIG_BINDING}"

echo "Generating initial HAProxy configuration..."
cat ${CONSUL_CONFIG_BINDING_TEMPLATE}
consul-template -consul ${CONSUL_URL} -template ${CONSUL_CONFIG_BINDING} -once
cat ${CONSUL_CONFIG_BINDING_CONFIG}

echo "Starting HAProxy..."
haproxy -f ${CONSUL_CONFIG_BINDING_CONFIG} -p /var/run/haproxy.pid -D

echo "Binding gracefully restart for HAProxy..."
consul-template -consul ${CONSUL_URL} -log-level info -template "${CONSUL_CONFIG_BINDING}:haproxy -f ${CONSUL_CONFIG_BINDING_CONFIG} -p /var/run/haproxy.pid -sf $(cat /var/run/haproxy.pid)"