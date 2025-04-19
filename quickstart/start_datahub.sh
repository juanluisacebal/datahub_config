#!/bin/bash
cd /home/juanlu/.datahub/quickstart
export DATAHUB_MAPPED_MYSQL_PORT=33306
export DATAHUB_MAPPED_ZK_PORT=32181
export ARCH=arm64

/home/juanlu/.local/bin/datahub docker quickstart --quickstart-compose-file docker-compose.yml