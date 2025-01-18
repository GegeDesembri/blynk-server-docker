FROM alpine:latest
MAINTAINER Gege Desembri <gegefcp@gmail.com>

#############################################################
#
# ENV VARS
#
# HARDWARE_PORT		Hardware without SSL/TLS support
# HARDWARE_PORT_SSL	Hardware port with SSL/TLS support
# HTTP_PORT			Blynk Dashboard
#
# BLYNK_SERVER_VERSION	 Blynk Server JAR version
#
###

## Static Directory and File listing
ENV DIR_PARENT="/blynk" \
	DIR_DATA="/blynk/data" \
	DIR_CONFIG="/blynk/config" \
	DIR_LOG="/blynk/logs" \
	FILE_CONFIG="/blynk/config/server.properties"

## Server Port
ENV BLYNK_SERVER_VERSION="0.41.18-SNAPSHOT" \
	HARDWARE_MQTT_PORT="8440" \
	HTTP_PORT="8080" \
	HTTPS_PORT="9443"

## SSL
#ENV SERVER_SSL_CERT
#	SERVER_SSL_KEY
#	SERVER_SSLKEY_PASS

## LOGS
ENV LOG_LEVEL="info"

## OTHERS

ENV FORCE_PORT_80_FOR_CSV="false" \
	FORCE_PORT_80_FOR_REDIRECT="true" \
	USER_DEVICES_LIMIT="50" \
	USER_TAGS_LIMIT="100" \
	USER_DASHBOARD_MAX_LIMIT="100" \
	USER_WIDGET_MAX_SIZE_LIMIT="20" \
	USER_MESSAGE_QUOTA_LIMIT="100" \
	NOTIFICATIONS_QUEUE_LIMIT="2000" \
	BLOCKING_PROCESSOR_THREAD_POOL_LIMIT="6" \
	NOTIFICATIONS_FREQUENCY_USER_QUOTA_LIMIT="5" \
	WEBHOOKS_FREQUENCY_USER_QUOTA_LIMIT="1000" \
	WEBHOOKS_RESPONSE_SIZE_LIMIT="96" \
	USER_PROFILE_MAX_SIZE="128" \
	TERMINAL_STRINGS_POOL_SIZE="25" \
	MAP_STRINGS_POOL_SIZE="25" \
	LCD_STRINGS_POOL_SIZE="6" \
	TABLE_ROWS_POOL_SIZE="100" \
	PROFILE_SAVE_WORKER_PERIOD="60000" \
	STATS_PRINT_WORKER_PERIOD="60000" \
	WEB_REQUEST_MAX_SIZE="524288" \
	CSV_EXPORT_DATA_POINTS_MAX="43200" \
	HARD_SOCKET_IDLE_TIMEOUT="10" \
	ADMIN_ROOT_PATH="/admin" \
	PRODUCT_NAME="Blynk" \
	RESTORE_HOST="blynk-cloud.com" \
	ALLOW_STORE_IP="true" \
	ALLOW_READING_WIDGET_WITHOUT_ACTIVE_APP="false" \
	ASYNC_LOGGER_RING_BUGGER_SIZE="2048"

## DB
ENV ENABLE_DB="false" \
	ENABLE_RAW_DB_DATA_STORE="false"

## Users
ENV INITIAL_ENERGY="100000" \
	ADMIN_EMAIL="admin@mail.com" \
	ADMIN_PASS="admin"


############################################################
# Install OpenJDK
RUN apk update && \
	apk add bash && \
	apk add openjdk11-jre-headless --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community

############################################################

RUN mkdir ${DIR_PARENT} && \
	mkdir ${DIR_DATA} && \
	mkdir ${DIR_CONFIG} && \
	mkdir ${DIR_LOG} && \
	touch ${FILE_CONFIG}

COPY "server-0.41.18-SNAPSHOT.jar" "/blynk/server.jar"
COPY "entrypoint.sh" "/usr/local/bin/entrypoint.sh"
	
VOLUME ["/blynk/config", "/blynk/data/backup"]

EXPOSE ${HARDWARE_MQTT_PORT} ${HARDWARE_MQTT_PORT_SSL} ${HTTP_PORT} ${HTTPS_PORT}

ENTRYPOINT entrypoint.sh
