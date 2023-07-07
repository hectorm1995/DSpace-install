# DSpace-install
# Instalacion BACKEND en ubuntu 22.05

# Actualizar y mejorar el sistema ubuntu
sudo apt update && sudo apt upgrade -y
	
# Instalar git (paquete de apoyo para la instalación de DSpace)
sudo apt install git

# Instalar el kit de desarrollo de Java (JDK)
sudo apt install default-jdk

# Puede comprobar la versión de java con el siguiente comando 
# (las versiones JDK 11 y JDK 17 son totalmente compatibles con dsapce7)
java -version

# Abra el siguiente archivo para activar la variable de entorno JAVA_HOME & JAVA_OPTS
sudo nano /etc/environment 

# Pegar las siguientes lineas de codigo
JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"
JAVA_OPTS="-Djava.awt.headless=true -Xmx2048m -Xms1024m -XX:MaxPermSize=1024m"

# Guardar y Salir

# Compruebe si JAVA_HOME & JAVA_OPTS se han configurado correctamente
echo $JAVA_HOME
echo $JAVA_OPTS

# Instale Apache Maven y Apache Ant en el directorio etc
cd /etc
sudo apt install maven -y
sudo apt install ant -y

# Instalar la base de datos Postgresql y los paquetes relacionados
sudo apt install postgresql postgresql-client postgresql-contrib
 
# Check the Postgres version
psql -V psql

# Anote el número de versión. Los números de versión varían en Ubuntu 20.04, 22.04 y Debian-11. En mi caso, se trata de la versión 14. Sustituya el número de versión en el siguiente comando si su distribución de Linux es distinta de Ubuntu 22.04)
sudo pg_ctlcluster 14 main start

# Establecer la contraseña para Postgres
sudo passwd postgres
# admin2023

#  Ingrese al usuario postgres
su postgres

# Ejecute los siguientes comandos para comprobar si UTF8 está activado 
cd /etc/postgresql/14/main
psql -c "SHOW SERVER_encoding"

# Si todo esta bien debe aparecer esto
postgres@tics:/etc$ cd /etc/postgresql/14/main
postgres@tics:/etc/postgresql/14/main$ psql -c "SHOW SERVER_encoding"
 server_encoding 
-----------------
 UTF8
(1 row)

# Salir del usuario postgres 
exit

# Descomenta la siguiente línea eliminando '#' en la opción de configuración de la conexión
sudo nano  /etc/postgresql/14/main/postgresql.conf
Descomente : listen_addresses = 'localhost'

# Encuentre la línea "# Database administrative login by Unix domain socket" y añada la siguiente línea encima de esta línea
sudo nano /etc/postgresql/14/main/pg_hba.conf
host dspace dspace 127.0.0.1 255.255.255.255 md5

# Reinicie PostgreSQL
sudo systemctl restart postgresql
sudo systemctl enable postgresql
sudo systemctl start postgresql

# Instale Solr en el directorio opt (Aplique los siguientes comandos)
cd /opt
sudo wget  https://downloads.apache.org/lucene/solr/8.11.2/solr-8.11.2.zip

# Instalación de unzip 
sudo apt install unzip
sudo unzip solr-8.11.2.zip
sudo rm solr-8.11.2.zip

# Cambiar los permisos del directorio solr (tics:tics se reemplaza por el usuario del pc)
sudo chown -R tics:tics solr-8.11.2

# Creer el directorio dspace en el directorio raíz (/)
cd /
sudo mkdir /dspace

# Cambiale los permisos al directorio /dspace
sudo chown -R tics:tics/dspace

# Ingrese a .profile y (pegue la siguiente línea en el archivo para iniciar automáticamente Solr y guarde el archivo) (Anexo1)
cd
nano .profile
/opt/solr-8.11.2/bin/solr start
 
# Ahora aplica los siguientes comandos desde la terminal para iniciar el solr (Anexo 2)
/opt/solr-8.11.2/bin/solr start


# Abra la siguiente URL en el navegador y verifique si el panel de administración de Solr está cargado (Anexo 3)
http://localhost:8983/solr

# Instalar TOMCAT9
cd
sudo apt install tomcat9

# Abre el siguiente archivo, agregue la siguiente línea en la parte inferior debajo de la seguridad (Anexo 4)
sudo nano /lib/systemd/system/tomcat9.service
ReadWritePaths=/dspace

# Abra el siguiente archivo en la carpeta tomcat
sudo nano /etc/tomcat9/server.xml
(Encuentre las siguientes líneas en el archivo)
<Connector port="8080" protocol="HTTP/1.1"
                   connectionTimeout="20000"
                   redirectPort="8443" />
(Reemplace las líneas anteriores con las siguientes líneas)
 <Connector port="8080" protocol="HTTP/1.1"
            minSpareThreads="25"
            enableLookups="false"
            redirectPort="8443"
            connectionTimeout="20000"
            disableUploadTimeout="tru
# Ejecute el siguiente comando
sudo systemctl daemon-reload

# Inicia el servicio de Tomcat y reinicie el Tomcat
sudo systemctl restart tomcat9.service
sudo systemctl enable tomcat9.service
sudo systemctl start tomcat9.service

# Instalacion  back-end de Dspace
wget https://github.com/DSpace/DSpace/archive/refs/tags/dspace-7.5.zip
unzip dspace-7.5.zip
sudo rm dspace-7.5.zip

# Cambiar el permiso al directorio dspace
sudo chown -R tics:tics DSpace-dspace-7.5

# Acceso a PostgreSQL
echo "host dspace dspace 127.0.0.1/32 md5" | sudo tee -a /etc/postgresql/14/main/pg_hba.conf

sudo sed -i 's/ident/trust/' /etc/postgresql/14/main/pg_hba.conf
sudo sed -i 's/md5/trust/' /etc/postgresql/14/main/pg_hba.conf
sudo sed -i 's/peer/trust/' /etc/postgresql/14/main/pg_hba.conf

sudo systemctl restart postgresql

# Configuración de base de datos 
su postgres

# Ingrese al siguiente directorio (cambie el número de versión de Postgres según corresponda)
cd /etc/postgresql/14/main
createuser dspace
createdb dspace -E UNICODE
psql -d dspace
CREATE EXTENSION pgcrypto;

# Crear una contraseña
ALTER ROLE dspace WITH PASSWORD 'dspace';
ALTER DATABASE dspace OWNER TO dspace;
GRANT ALL PRIVILEGES ON DATABASE dspace TO dspace;
\q
exit
sudo systemctl restart postgresql

# Configuración de DSpace (Ingrese al directorio de configuración de dspace)
cd
cd DSpace-dspace-7.5/dspace/config

# Haga una copia del archivo 'local.cfg.EXAMPLE' llamado 'local.cfg'
cp local.cfg.EXAMPLE local.cfg
nano local.cfg

# (Cambia el nombre de tu repositorio)
dspace.name = DSpace at CRUZ ROJA JPI 
dspace.server.url = http://192.168.3.105:8080/server
dspace.ui.url = http://192.168.3.105:4000
# Descomentar : 
solr.server = http://localhost:8983/solr

# Este lo dejamos con localhost
db.url = jdbc:postgresql://localhost:5432/dspace
# (Cambie el nombre de usuario y la contraseña de la base de datos si hay algún cambio)
db.username = dspace
db.password = dspace  
# Guardar y salir

# Guarda la anterior configuración y dirige al directorio DSpace-dspace-7.5, luego cree el paquete de instalación (Anexo 5)
cd DSpace-dspace-7.5/
mvn package

# Instale DSpace Backend (Ingrese al directorio de instalación de dspace)
cd /home/tics/DSpace-dspace-7.5/dspace/target/dspace-installer/
ant fresh_install

# Inicializar la Base de Datos (Aplicar los siguientes comandos)
cd /dspace/bin
./dspace database migrate
# Si todo esta bien debe mostrarse como la figura del ANEXO 6

# Copie el directorio de aplicaciones web de dspace en el servidor Tomcat
sudo cp -R /dspace/webapps/* /var/lib/tomcat9/webapps*

# Ahora copie el directorio Solr
cd /dspace/solr
cp -R /dspace/solr/* /opt/solr-8.11.2/server/solr/configsets

# Ahora reinicie el Solr
cd /opt/solr-8.11.2/bin
./solr restart

# Cambie los permisos de dspace a Tomcat User
sudo chown -R tomcat:tomcat /dspace

# Reinicie el Tomcat
sudo systemctl restart tomcat9.service

# VErificar si el backend esta bien realizado (Anexo 7)
http://192.168.3.105:8080/server/#/server/api







