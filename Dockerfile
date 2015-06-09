FROM 		haproxy
MAINTAINER 	Per-Gustaf Stenberg

ENV CONSUL_CONFIG_BINDING /usr/local/etc/haproxy/haproxy.cfg.tmpl:/usr/local/etc/haproxy/haproxy.cfg

ADD run.sh /usr/local/bin/haproxy-consul
ADD consul-template_0.9.0_linux_amd64 /usr/local/bin/consul-template

RUN chmod +x /usr/local/bin/haproxy-consul
RUN chmod +x /usr/local/bin/consul-template

ADD haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg.tmpl

ENTRYPOINT ["haproxy-consul"]