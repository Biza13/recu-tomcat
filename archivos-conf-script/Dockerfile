FROM httpd:2.4

# Copiar el archivo de configuración personalizado
COPY httpd.conf /usr/local/apache2/conf/httpd.conf

# Exponer el puerto 80
EXPOSE 80

# Iniciar Apache en primer plano (foreground)
CMD ["httpd", "-D", "FOREGROUND"]
