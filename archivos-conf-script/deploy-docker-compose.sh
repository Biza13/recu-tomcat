#!/bin/bash

# Función para imprimir mensajes con color
function log_message {
    echo -e "\033[1;34m$1\033[0m"
}

# Función para manejar errores
function handle_error {
    log_message "ERROR: $1"
    exit 1
}

# Actualizar el sistema
log_message "Actualizando el sistema..."
sudo yum update -y || handle_error "Falló la actualización del sistema"

# Instalar Docker
log_message "Instalando Docker..."
sudo amazon-linux-extras install docker -y || handle_error "Falló la instalación de Docker"
sudo systemctl enable --now docker || handle_error "Falló al iniciar Docker"

# Configurar usuario docker sin sudo
sudo usermod -aG docker ec2-user || handle_error "Falló al configurar grupos de usuario"

# Instalar dependencias necesarias
log_message "Instalando dependencias necesarias..."
sudo yum install -y git awscli curl || handle_error "Falló la instalación de dependencias"

# Verificar Docker
if ! command -v docker &>/dev/null; then
    handle_error "Docker no está instalado correctamente"
fi

# Instalar Docker Compose v2
log_message "Instalando Docker Compose v2..."
DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
mkdir -p $DOCKER_CONFIG/cli-plugins || handle_error "Falló al crear directorio"

# Descargar Docker Compose
COMPOSE_URL="https://github.com/docker/compose/releases/latest/download/docker-compose-linux-$(uname -m)"
if ! curl -SL "$COMPOSE_URL" -o $DOCKER_CONFIG/cli-plugins/docker-compose; then
    handle_error "Falló al descargar Docker Compose"
fi

# Permisos de ejecución
chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose || handle_error "Falló al dar permisos"

# Verificar Docker Compose
if ! docker compose version &>/dev/null; then
    handle_error "Docker Compose no funciona correctamente"
fi

# Mostrar versiones
log_message "Versiones instaladas:"
docker --version || handle_error "No se puede obtener versión de Docker"
docker compose version || handle_error "No se puede obtener versión de Docker Compose"

# Configurar entorno para el usuario actual (evita necesidad de logout)
newgrp docker <<EONG
# Ejecutar los contenedores
log_message "Iniciando contenedores..."
cd ~/archivos-conf-script || handle_error "No se encontró el directorio del proyecto"

# Asegurar que httpd.conf tiene la configuración correcta
if ! grep -q "LoadModule mpm_event_module" httpd.conf; then
    sed -i '1iLoadModule mpm_event_module modules/mod_mpm_event.so' httpd.conf
fi

docker compose up -d || handle_error "Falló al iniciar los contenedores"

# Verificar contenedores
log_message "Estado de los contenedores:"
docker ps || handle_error "Falló al verificar contenedores"

log_message "Proceso completado exitosamente. Accede a:"
log_message " - http://bego.work.gd"
log_message " - http://bego1.work.gd"
EONG