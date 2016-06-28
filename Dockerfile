FROM tutum/curl:trusty
MAINTAINER Jan Antala <j.antala@pygmalios.com>

# Install InfluxDB for CLI
ENV INFLUXDB_VERSION 1.0.0-beta1

RUN curl -s -o /tmp/influxdb_latest_amd64.deb https://dl.influxdata.com/influxdb/releases/influxdb_${INFLUXDB_VERSION}_amd64.deb && \
  dpkg -i /tmp/influxdb_latest_amd64.deb && \
  rm /tmp/influxdb_latest_amd64.deb && \
  rm -rf /var/lib/apt/lists/*

# Include files
ADD init_script.influxql /init_script.influxql
ADD post_run.sh /post_run.sh
RUN chmod +x /*.sh

# Default command
ENTRYPOINT ["/post_run.sh"]
