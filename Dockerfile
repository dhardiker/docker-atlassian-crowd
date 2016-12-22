FROM jleight/atlassian-base:latest
MAINTAINER Jonathon Leight <jonathon.leight@jleight.com>

ENV APP_VERSION 2.10.1
ENV APP_BASEURL ${ATL_BASEURL}/crowd/downloads/binary
ENV APP_PACKAGE atlassian-crowd-${APP_VERSION}.tar.gz
ENV APP_URL     ${APP_BASEURL}/${APP_PACKAGE}
ENV APP_PROPS   crowd-webapp/WEB-INF/classes/crowd-init.properties
ENV APP_DB_DRIVER_URL https://jdbc.postgresql.org/download/postgresql-9.4.1212.jre6.jar

RUN set -x \
  && curl -kL "${APP_URL}" | tar -xz -C "${ATL_HOME}" --strip-components=1 \
  && chown -R "${ATL_USER}":"${ATL_USER}" "${ATL_HOME}" \
  && chmod -R 755 "${ATL_HOME}/apache-tomcat/temp" \
  && chmod -R 755 "${ATL_HOME}/apache-tomcat/logs" \
  && chmod -R 755 "${ATL_HOME}/apache-tomcat/work" \
  && echo -e "\ncrowd.home=${ATL_DATA}" >> "${ATL_HOME}/${APP_PROPS}" \
  && cd "${ATL_HOME}/crowd-webapp/WEB-INF/lib/" \
  && curl -O "${APP_DB_DRIVER_URL}" \
  && cd -

ADD crowd-service.sh /opt/crowd-service.sh
ADD ping.json "${ATL_HOME}/apache-tomcat/webapps/ROOT/ping.json"

EXPOSE 8095
CMD ["/opt/crowd-service.sh"]
