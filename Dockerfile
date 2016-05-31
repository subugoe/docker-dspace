
FROM ubuntu:16.04

ENV TOMCAT_VERSION 8.0.33
ENV DSPACE_VERSION 5.5

# Set locales
RUN locale-gen en_GB.UTF-8
ENV LANG en_GB.UTF-8
ENV LC_CTYPE en_GB.UTF-8

# Fix sh
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Install dependencies
RUN apt-get update && apt-get install -y git build-essential curl wget software-properties-common nano

# Install JDK 8
RUN apt-get update && apt-get install -y openjdk-8-jdk openjdk-8-demo openjdk-8-doc openjdk-8-jre-headless openjdk-8-source

# Get Tomcat
RUN wget --quiet --no-cookies http://apache.rediris.es/tomcat/tomcat-8/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz -O /tmp/tomcat.tgz && \
tar xzvf /tmp/tomcat.tgz -C /opt && \
mv /opt/apache-tomcat-${TOMCAT_VERSION} /opt/tomcat

# Add admin/admin user
COPY tomcat-users.xml /opt/tomcat/conf/tomcat-users.xml
COPY setenv.sh /opt/tomcat/bin/setenv.sh

# Maven, Ant installieren
RUN apt-get update && \
apt-get install -y maven ant

# DSpace-User anlegen, default-root-Passwort ändern
RUN useradd -m dspace 
RUN echo "dspace:dspace" | chpasswd
#RUN echo "root:a1b2c3" | chpasswd

# tomcat-Ordner dspace geben, tomcat als dspace starten
RUN chown -R dspace /opt/tomcat

# Ordner für dspace erstellen und Rechte User dspace geben
RUN mkdir /home/dspace/dspace-5.5-src
RUN mkdir /opt/dspace
RUN mkdir /opt/dspace/geoleo
RUN chown -R dspace /opt/dspace
RUN chown -R dspace /home/dspace

# Umgebungsvariablen setzen
ENV CATALINA_HOME /opt/tomcat
ENV PATH $PATH:$CATALINA_HOME/bin
ENV TERM xterm
ENV DEPLOY_DIR /opt/dspace/geo-leo/webapps
ENV SRC_DIR /home/dspace/dspace-5.5-src

EXPOSE 8080

# Benutzer wechseln, damit tomcat als dspace-User gestartet wird anstatt als root
USER dspace

# Get dspace
RUN cd /home/dspace/; curl -L https://github.com/DSpace/DSpace/archive/dspace-${DSPACE_VERSION}.tar.gz | tar xz
RUN mv /home/dspace/DSpace-dspace-5.5/* /home/dspace/dspace-5.5-src 

# DSpace-Konfig anpassen
RUN cd ${SRC_DIR} && sed -i -e "s%dspace.install.dir=/dspace%dspace.install.dir=/opt/dspace/geoleo%g" build.properties
RUN cd ${SRC_DIR} && sed -i -e "s%dspace.hostname = localhost%dspace.hostname = hostip%g" build.properties
RUN cd ${SRC_DIR} && sed -i -e "s%dspace.baseUrl = http://localhost:8080%dspace.baseUrl = http://hostip:8080%g" build.properties
RUN cd ${SRC_DIR} && sed -i -e "s%db.url=jdbc:postgresql://localhost:5432/dspace%db.url=jdbc:postgresql://postgres:5432/dspace%g" build.properties

# build it
RUN cd ${SRC_DIR} && mvn package -Dmirage2.on=true

VOLUME /home/dspace
VOLUME /opt/dspace

ENV TERM=xterm

# Launch Tomcat
CMD ["/opt/tomcat/bin/catalina.sh", "run"]
