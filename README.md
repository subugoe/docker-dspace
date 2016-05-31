# docker-dspace
Docker-Image für DSpace

Doku:

1. git clone https://github.com/subugoe/docker-dspace.git
2. in Dockerfile Zeilen 66 & 67 hostip ändern
2. optional: in Dockerfile Projektnamen geo-leo ändern (Zeilen 44, 52, 65)
3. optional: in docker-compose.yml Ports, Resource-Limits ändern
4. docker-comopose up -d
5. DB-User und DB anlegen: docker exec -it dspace_postgres_1 /bin/bash
   a.) createuser -U postgres -d -A -P dspace
   b.) createdb -U dspace -E UNICODE dspace
   c.) exit
6. DSpace-Installation abschließen: docker exec -it dspacetestr /bin/bash
   a.) cd /home/dspace/dspace-5.5-src/dspace/target/dspace-installer
   b.) ant fresh_install
   c.) webapps von /opt/dspace/geo-leo/webapps zu /opt/tomcat/webapps kopieren oder symlinks setzen
   d.) /opt/dspace/geoleo/bin/dspace create-administrator
   e.) exit
7. http://localhost:8082/xmlui
