FROM            debian:wheezy
MAINTAINER      Per-Gustaf Stenberg

ENV CONSUL_CONFIG_BINDING_TEMPLATE_FOLDER /tmp/haproxy-config
ENV CONSUL_CONFIG_BINDING_TEMPLATE ${CONSUL_CONFIG_BINDING_TEMPLATE_FOLDER}/haproxy.cfg.tmpl
ENV CONSUL_CONFIG_BINDING_CONFIG /etc/haproxy/haproxy.cfg
ENV CONSUL_CONFIG_BINDING ${CONSUL_CONFIG_BINDING_TEMPLATE}:${CONSUL_CONFIG_BINDING_CONFIG}

ENV CONSUL_URL 127.0.0.1:8500

ENV CONSUL_VER 0.10.0
ENV CONSUL_BIN linux_amd64

#Install HAPROXY
RUN echo "deb http://cdn.debian.net/debian wheezy-backports main" > /etc/apt/sources.list.d/backports.list
RUN apt-get update && apt-get install -y --force-yes haproxy -t wheezy-backports

#Install consul-template
RUN apt-get update && apt-get install -y wget && wget --no-check-certificate http://github.com/hashicorp/consul-template/releases/download/v${CONSUL_VER}/consul-template_${CONSUL_VER}_${CONSUL_BIN}.tar.gz
RUN tar -zxvf consul-template_${CONSUL_VER}_${CONSUL_BIN}.tar.gz && mv consul-template_${CONSUL_VER}_${CONSUL_BIN}/consul-template /usr/local/bin/consul-template

#Add entrypoint script
ADD start.sh /usr/local/bin/haproxy-consul

#Make bins executable
RUN chmod +x /usr/local/bin/haproxy-consul
RUN chmod +x /usr/local/bin/consul-template

EXPOSE 80

ENTRYPOINT ["haproxy-consul"]