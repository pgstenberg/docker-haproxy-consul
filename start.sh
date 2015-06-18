#!/bin/sh

echo "Setting up proxy agains consul-url ${CONSUL_URL}."
echo "Binding configuration with ${CONSUL_CONFIG_BINDING}"

echo "Found template ${CONSUL_CONFIG_BINDING_TEMPLATE}:"
cat ${CONSUL_CONFIG_BINDING_TEMPLATE}

echo "Generating initial HAProxy configuration..."
consul-template -consul ${CONSUL_URL} -template ${CONSUL_CONFIG_BINDING} -once
cat ${CONSUL_CONFIG_BINDING_CONFIG}

echo "Starting HAProxy..."
service haproxy start

echo "Binding gracefully restart for HAProxy..."
consul-template -consul ${CONSUL_URL} -log-level debug -template "${CONSUL_CONFIG_BINDING}:service haproxy reload"