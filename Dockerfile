FROM            haproxy
MAINTAINER      Per-Gustaf Stenberg

ENV CONSUL_CONFIG_BINDING_TEMPLATE /tmp/haproxy.cfg.tmpl
ENV CONSUL_CONFIG_BINDING_CONFIG /usr/local/etc/haproxy/haproxy.cfg
ENV CONSUL_CONFIG_BINDING ${CONSUL_CONFIG_BINDING_TEMPLATE}:$CONSUL_CONFIG_BINDING_CONFIG

ENV CONSUL_URL 127.0.0.1:8500

ENV CONSUL_VER 0.10.0
ENV CONSUL_BIN freebsd_amd64

#Install consul-template
RUN apt-get update && apt-get install -y wget
RUN wget --no-check-certificate http://github.com/hashicorp/consul-template/releases/download/v${CONSUL_VER}/consul-template_${CONSUL_VER}_${CONSUL_BIN}.tar.gz
RUN tar -zxvf consul-template_${CONSUL_VER}_${CONSUL_BIN}.tar.gz && mv consul-template_${CONSUL_VER}_${CONSUL_BIN}/consul-template /usr/local/bin/consul-template

#Add entrypoint script
ADD start.sh /usr/local/bin/haproxy-consul

#Make bins executable
RUN chmod +x /usr/local/bin/haproxy-consul
RUN chmod +x /usr/local/bin/consul-template

ENTRYPOINT ["haproxy-consul"]