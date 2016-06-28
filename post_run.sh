#!/bin/bash

set -e
API_URL="http://${INFLUX_HOST}:${INFLUX_API_PORT}"

#Create the admin user
if [ -n "$ADMIN" ] || [ -n "$PASS" ]; then
 echo "=> Creating admin user"
 influx -host=${INFLUX_HOST} -port=${INFLUX_API_PORT} -execute="CREATE USER ${ADMIN} WITH PASSWORD '${PASS}' WITH ALL PRIVILEGES"
fi
  
# Pre create database on the initiation of the container
if [ -n "${PRE_CREATE_DB}" ]; then
 echo "=> About to create the following database: ${PRE_CREATE_DB}"
 arr=$(echo ${PRE_CREATE_DB} | tr ";" "\n")
 for x in $arr
  do
   echo "=> Creating database: ${x}"
   echo "CREATE DATABASE ${x}" >> /tmp/init_script.influxql
  done
fi
  
# Execute influxql queries contained inside /init_script.influxql
echo "=> About to execute the initialization script"
cat /init_script.influxql >> /tmp/init_script.influxql
echo "=> Executing the influxql script..." 
influx -host=${INFLUX_HOST} -port=${INFLUX_API_PORT} -username=${ADMIN} -password="${PASS}" -import -path=/tmp/init_script.influxql
echo "=> Influxql script executed." 
