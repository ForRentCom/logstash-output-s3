#!/bin/bash

set -e

if [ ! -f /etc/logstash/conf.d/logstash.conf ]; then
	/usr/bin/envsubst '$INPUT $FILTER $OUTPUT' < /etc/logstash/conf.d/template/logstash.conf-template > /etc/logstash/conf.d/logstash.conf
fi

exec /usr/share/logstash/bin/logstash -f /etc/logstash/conf.d/logstash.conf
