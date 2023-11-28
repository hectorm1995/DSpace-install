# Instalar certificado SSL a repositorio creado
sudo apt install apache2 -y
sudo a2enmod proxy
systemctl restart apache2
sudo a2enmod proxy_http
systemctl restart apache2

sudo apt install vim

# Error en apache
sudo apt-get autoremove --purge apache2
systemctl start apache2
# SI todo esta bien al colocar http://Ip debe mostrar servidor de apache funcionando

#CERTBOT Instala los  certificados del dominio de una web
sudo snap install core; sudo snap refresh core
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot
sudo certbot --apache
sudo apt-get install python3-certbot-apache

sudo nano /etc/httpd/conf/httpd.conf
# añadir al final del archivo
. . .
# Supplemental configuration
#
# Load config files in the "/etc/httpd/conf.d" directory, if any.
IncludeOptional conf.d/*.conf
ServerName 127.0.0.1
