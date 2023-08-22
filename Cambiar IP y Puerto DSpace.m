#BACKEND

# Configuración de DSpace (Ingrese al directorio de configuración de dspace)
cd
cd DSpace-dspace-7.5/dspace/config

# Haga una copia del archivo 'local.cfg.EXAMPLE' llamado 'local.cfg'
cp local.cfg.EXAMPLE local.cfg
nano local.cfg

#FRONTEND



# Ingresamos al directorio de instalación de DSpace:
cd /dspace/config/

# Ingresamos al archivo de configuración
sudo nano local.cfg

# Se cambia la direcciòn IP como se muestra en la figura Anexo 1

# Ingresamos al siguiente directorio
cd /home/tics/dspace-angular-dspace-7.5/config

# Ingresamos al archivo de configuracion y cambiamos la IP (Anexo 2)
sudo nano config.prod.yml

# Reiniciamos tomcat
sudo systemctl restart tomcat9.service

# Reiniciamos el servicio pm2 
cd /home/tics/dspace-angular-dspace-7.5
pwd
pm2 start dspace-ui.json


