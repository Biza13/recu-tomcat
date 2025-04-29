FROM alpine:latest

# Instalación de Apache y módulos necesarios
RUN apk update && \
    apk add --no-cache apache2 apache2-utils \
    apache2-mod-proxy \
    apache2-mod-proxy-http \
    apache2-mod-rewrite \
    apache2-mod-headers \
    apache2-mod-ssl && \
    # Habilitar los módulos
    sed -i '/#LoadModule proxy_module/ s/^#//g' /etc/apache2/httpd.conf && \
    sed -i '/#LoadModule proxy_http_module/ s/^#//g' /etc/apache2/httpd.conf && \
    sed -i '/#LoadModule rewrite_module/ s/^#//g' /etc/apache2/httpd.conf && \
    sed -i '/#LoadModule headers_module/ s/^#//g' /etc/apache2/httpd.conf && \
    sed -i '/#LoadModule ssl_module/ s/^#//g' /etc/apache2/httpd.conf

COPY httpd.conf /etc/apache2/httpd.conf

EXPOSE 80

# Iniciar Apache en primer plano (foreground)
CMD ["httpd", "-D", "FOREGROUND"]
