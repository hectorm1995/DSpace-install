# Instalar node version manager
cd
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

# Cerramos y abrimos el terminal nuevamente
# Instalar NVM
sudo apt install npm
nvm ls-remote
cd
nvm install --lts
node -v

# Instalar Yarn 
npm install --global yarn

# Instalación de pm2
npm install --global pm2

# Instalación del Frontend de dspace, descargue dspace Angular
wget https://github.com/DSpace/dspace-angular/archive/refs/tags/dspace-7.5.zip

# Descomprima el archivo zip
unzip dspace-7.5.zip

# Elimine el archivo zip ya que no es necesario
sudo rm dspace-7.5.zip

# Instalar Yarn en el directorio angular de dspace (ver Anexo 8)
cd /home/tics/dspace-angular-dspace-7.5
yarn install

# Copie y cambie el nombre del archivo de configuración
cd config 
cp config.example.yml config.prod.yml

# Ingrese al archivo y realice los siguientes cambios 
nano config.prod.yml
ui:
  ssl: false
  host: localhost
  port: 4000

rest:
  ssl: false
  host: localhost
  port: 8080
  # NOTE: Space is capitalized because 'namespace' is a reserved string in Type>
  nameSpace: /server

# Construye la interfaz de dspace
yarn build:prod

# Pruebe que esté funcionando 
# Debe dar una respuesta con numeros 200, en este caso todo estaría funcionando correctamente (Anexo 9)

cd /home/dspace/dspace-angular-dspace-7.5
yarn test:rest

# Cree el archivo dspace-ui.json
cd /home/tics/dspace-angular-dspace-7.5
nano dspace-ui.json

{
    "apps": [
        {
           "name": "dspace-ui",
           "cwd": "/home/tics/dspace-angular-dspace-7.5",
           "script": "dist/server/main.js",
           "instances": "max",
           "exec_mode": "cluster",
           "env": {
              "NODE_ENV": "production"
           }
        }
    ]
}

Nota
En la parte de cwd : debes poner la ruta del directorio de angular de dspace

# Inicie pm2 (ver Anexo 10)
cd /home/tics/dspace-angular-dspace-7.5
pwd
pm2 start dspace-ui.json

# Ahora es el momento de probarlo, ingresa en la web y digita tu Ip y el puerto 4000 o el que configuraste (Ver Anexo 11)
http://localhost:4000

# Revisa el funcionamiento de dspace con el siguiente comando, la respuesta debe ser 2000 
pm2 logs

# Mueve la ubicación del archivo dspace-ui.json
mv  /home/tics/dspace-angular-dspace-7.5/dspace-ui.json /home/tics

# Dirígete al home e ingresa a .profile
cd
nano .profile

# Agrega : bash -ci 'pm2 start dspace-ui.json' debajo del comando que activa Solr (Ver Anexo 12)
#umask 022
/opt/solr-8.11.2/bin/solr start
bash -ci 'pm2 start dspace-ui.json'
# if running bash

# Guárdala anterior configuración y deten el proceso de pm2 
pm2 stop dspace-ui.json

# Reinicia la máquina
reboot

Nota: Luego de que la máquina se reinicie no debes  agregar ningún comando  sino ingresar 
directo a dspace vía web, te recomiendo primero revisar que puedas acceder a la API y 
luego ingresar a tu repositorio



