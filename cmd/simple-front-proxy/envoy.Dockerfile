FROM envoyproxy/envoy:v1.11.0

EXPOSE 4999
EXPOSE 19000

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -qq update && \
    apt-get -qq install  \
                apt-utils \
                iputils-ping \
                curl \
                < /dev/null > /dev/null

ADD ./service-envoy.yaml /etc/service-envoy.yaml
ADD ./start_envoy.sh /usr/local/bin/start_envoy.sh
WORKDIR /usr/local/bin
RUN chmod u+x start_envoy.sh
ENTRYPOINT ./start_envoy.sh


