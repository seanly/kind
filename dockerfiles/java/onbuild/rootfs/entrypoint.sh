#!/bin/bash

set -x

# 添加监控jmx agent
export JMX_OPTS=" -javaagent:/data/app/jmx_exporter/jmx_prometheus_javaagent-0.16.0.jar=10071:/data/app/jmx_exporter/prometheus-jmx-config.yaml"

JMX_ENABLE=${JMX_ENABLE:-false}

if [ "${JMX_ENABLE}" == true ]; then
  export JAVA_OPTS="${JMX_OPTS} ${JAVA_OPTS}"
fi

export JAVA_OPTS="-XX:+UnlockExperimentalVMOptions -XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0 -XX:InitialRAMPercentage=75.0 ${JAVA_OPTS}"

#JAVA_OPTS
# XX:MaxRAMPercentage=75.0  -XX:InitialRAMPercentage=75.0 

# 执行业务启动程序
chmod 755 bin/start.sh
exec bin/start.sh $@
