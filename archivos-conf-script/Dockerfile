FROM httpd:2.4

RUN apt-get update && \
    apt-get install -y apache2-bin && \
    sed -i '/mod_proxy.so/s/^#//g' /usr/local/apache2/conf/httpd.conf && \
    sed -i '/mod_proxy_http.so/s/^#//g' /usr/local/apache2/conf/httpd.conf

    COPY httpd.conf /usr/local/apache2/conf/httpd.conf