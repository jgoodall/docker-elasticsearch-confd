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
RUN wget -O - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | apt-key add -
RUN echo "deb http://packages.elasticsearch.org/elasticsearch/1.2/debian stable main" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -qy elasticsearch
RUN mkdir -p /es-config

# DEBUG
RUN which elasticsearch

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