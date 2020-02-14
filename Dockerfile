# tomcat v8
FROM tomcat:8.5-jre8-alpine

# get latest updates
RUN apk update && apk upgrade && apk add bind-tools && rm -rf /var/cache/apk/*

RUN addgroup -S tomcat && \
    adduser -S tomcat -G tomcat
# Put server.xml

COPY files/server.xml $CATALINA_HOME/conf/

# Cleaning Tomcat
RUN rm -rf $CATALINA_HOME/webapps/* && \
    rm -rf $CATALINA_HOME/server/webapps/*

#ADD target/*.jar $CATALINA_HOME/lib/

RUN chgrp -R tomcat $CATALINA_HOME && \
    chmod -R g=u $CATALINA_HOME && \
    chown -R tomcat:tomcat $CATALINA_HOME && \
    chmod 644 $CATALINA_HOME/conf/server.xml

ENV PATH=$CATALINA_HOME
USER 100
#USER tomcat

CMD ["catalina.sh", "run"]
CMD exec /bin/sh -c "trap : TERM INT; (while true; do sleep 1000; done) & wait"
