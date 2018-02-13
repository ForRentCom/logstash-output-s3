FROM ubuntu:16.04

RUN apt-get update; apt-get install -y jruby curl vim gettext

RUN mkdir /code

COPY ./ /code/
 
RUN curl -s https://artifacts.elastic.co/downloads/logstash/logstash-5.6.7.deb -o logstash-5.6.7.deb \
 && apt-get install -y ./logstash-5.6.7.deb 

RUN cd /code/; jgem build logstash-output-s3.gemspec
# ??? Profit!
RUN /usr/share/logstash/bin/logstash-plugin install --no-verify 

# Approximately from frms-logstash-56

RUN /usr/share/logstash/bin/logstash-plugin remove logstash-codec-fluent
RUN /usr/share/logstash/bin/logstash-plugin install --version 3.1.1 logstash-codec-fluent

# Install Logstash REST Filter from gem
RUN /usr/share/logstash/bin/logstash-plugin install logstash-filter-rest

# Install Logstash HTTP Output
RUN /usr/share/logstash/bin/logstash-plugin install logstash-output-http

# Install Logstash Prune filter
RUN /usr/share/logstash/bin/logstash-plugin install logstash-filter-prune

# Copy config resources to default location
COPY ./resources /usr/share/logstash/vendor/jars
COPY ./template /etc/logstash/conf.d/template
COPY ./grok /etc/logstash/grok
COPY ./config/logstash.yml /usr/share/logstash/config/logstash.yml
COPY ./run-logstash.sh /bin/run-logstash.sh

ENTRYPOINT ["/bin/run-logstash.sh"]

