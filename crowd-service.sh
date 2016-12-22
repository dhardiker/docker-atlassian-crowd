#!/bin/sh

SERVER_XML="${ATL_HOME}/apache-tomcat/conf/server.xml"

# Remove other webapps if environment variables are set.
if [ $TC_ONLY_CROWD_WEBAPP = "true" ]; then
  echo "Removing non-crowd web applications from the distribution"
  find "${ATL_HOME}/apache-tomcat/conf/Catalina/localhost/" -type f | grep -v "crowd.xml" | xargs rm
fi

# Remove any previous proxy configuration.
sed -E 's/ proxyName="[^"]*"//g' -i "${SERVER_XML}"
sed -E 's/ proxyPort="[^"]*"//g' -i "${SERVER_XML}"

# Add new proxy configuration if environment variables are set.
if [ ! -z "${TC_PROXYNAME}" ]; then
  echo "Adding proxy name to connector"
  sed -E "s|<Connector|<Connector proxyName=\"${TC_PROXYNAME}\"|g" \
      -i "${SERVER_XML}"
fi
if [ ! -z "${TC_PROXYPORT}" ]; then
  echo "Adding proxy port to connector"
  sed -E "s|<Connector|<Connector proxyPort=\"${TC_PROXYPORT}\"|g" \
      -i "${SERVER_XML}"
fi

exec "${ATL_HOME}/apache-tomcat/bin/catalina.sh" run
