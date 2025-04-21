FROM tomcat:9.0-jdk17

# Limpia apps por defecto
RUN rm -rf /usr/local/tomcat/webapps/*

# Copia el .war compilado al Tomcat
COPY ./proyecto/target/Proyecto_java_jweb_banco_de_preguntas-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]