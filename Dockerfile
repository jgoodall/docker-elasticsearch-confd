FROM jgoodall/ubuntu-confd

MAINTAINER "John Goodall <jgoodall@ornl.gov>"

ENV DEBIAN_FRONTEND noninteractive

# Install Java
RUN apt-get install -qy software-properties-common
RUN add-apt-repository -y ppa:webupd8team/java
RUN apt-get update
RUN echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
RUN echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections
RUN apt-get install -qy oracle-java7-installer

# Install ElasticSearch
RUN cd /tmp && curl -qL https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.3.0.tar.gz | tar xzf - && mv /tmp/elasticsearch-1.3.0 /elasticsearch
RUN mkdir -p /es-config

# Set up run script
ADD run.sh /run.sh
RUN chmod 755 /run.sh

# Copy confd files
ADD confd/conf.d/elasticsearch.toml /etc/confd/conf.d/elasticsearch.toml
ADD confd/templates/elasticsearch.tmpl /etc/confd/templates/elasticsearch.tmpl

# Copy supervisord files
ADD supervisord.conf /etc/supervisor/supervisord.conf

EXPOSE 9200
EXPOSE 9300

VOLUME ["/data"]
WORKDIR /data

CMD ["/run.sh"]