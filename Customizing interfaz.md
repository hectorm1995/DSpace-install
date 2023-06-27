# configuracion de lenguajes
cd /home/tics/dspace-angular-dspace-7.5
cd config
nano config.prod.yml

# Colocar en true el idioma que se desea observar (Anexo 1)
# Reiniciar pm2 y verificar cambios (Anexo 2)
cd /home/tics/dspace-angular-dspace-7.5
pwd
pm2 stop dspace-ui.json
pm2 start dspace-ui.json

cd /home/tics/dspace-angular-dspace-7.5
yarn build:prod

