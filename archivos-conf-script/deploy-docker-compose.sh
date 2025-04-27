#!/bin/bash

# Actualizar el sistema
echo "Actualizando el sistema..."
sudo yum update -y

# Instalar Docker
echo "Instalando Docker..."
sudo amazon-linux-extras install docker -y
sudo systemctl enable --now docker

# Configurar usuario docker sin sudo
sudo usermod -aG docker ec2-user

# Instalar dependencias necesarias
echo "Instalando dependencias necesarias..."
sudo yum install -y git awscli curl

# Verificar si Docker está instalado
if ! command -v docker &> /dev/null
then
    echo "Docker no está instalado. Instalación fallida."
    exit 1
fi

# Instalar Docker Compose v2 (última versión estable)
echo "Instalando Docker Compose v2..."
DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
mkdir -p $DOCKER_CONFIG/cli-plugins

# Descargar Docker Compose v2
curl -SL "https://github.com/docker/compose/releases/latest/download/docker-compose-linux-$(uname -m)" \
    -o $DOCKER_CONFIG/cli-plugins/docker-compose

# Dar permisos de ejecución al archivo descargado
chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose

# Verificar si Docker Compose v2 está instalado
if ! command -v docker compose &> /dev/null
then
    echo "Docker Compose no está instalado correctamente. Instalación fallida."
    exit 1
fi

# Verificar la versión de Docker y Docker Compose
echo "Docker version:"
docker --version
echo "Docker Compose version:"
docker compose version

# Ejecutar docker compose up
echo "Ejecutando 'docker compose up'..."
cd archivos-conf-script
docker compose up -d

# Verificar si los contenedores están corriendo
docker ps

echo "El proceso ha terminado con éxito. Los contenedores deberían estar en ejecución."
