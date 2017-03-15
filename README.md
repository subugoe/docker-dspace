# docker-dspace
Docker-Image für DSpace

Anleitung:

1. git clone https://github.com/subugoe/docker-dspace.git

2. in Dockerfile Zeilen 66 & 67 hostip durch Host-IP ersetzen

3. in docker-compose.yml in Zeile 19 den Ordnernamen vom Pfad ändern: z.B. /docker/postgresuniverlag:/var/lib/postgresql/data statt/docker/postgrestest:/var/lib/postgresql/data; in Zeile 6 Port ändern

4. in Dockerfile "test" gegen Projektnamen ändern (Zeilen 44, 52, 65)

5. docker build -t dspace .

6. docker-compose up -d

7. DB-User und DB anlegen: docker exec -it dspace_postgres_1 /bin/bash
      1. createuser -U postgres -d -A -P dspace
      2. createdb -U dspace -E UNICODE dspace
      3. exit

8. DSpace-Installation abschließen: docker exec -it dspacetestr /bin/bash
      1. cd /home/dspace/dspace-5.6-src/dspace/target/dspace-installer
      2. ant fresh_install
      3. webapps von /opt/dspace/test/webapps zu /opt/tomcat/webapps kopieren oder symlinks setzen
      4. /opt/dspace/test/bin/dspace create-administrator
      5. exit

9. http://localhost:8081/xmlui

10. um XMLUI Mirage 2 (responsive) zu nutzen: in /opt/dspace/test/config/xmlui.xconf Theme ersetzen durch "theme name="Mirage 2" regex=".*" path="Mirage2/" />"

11. DSpace-Container neustarten: docker restart dspace_dspace_1
