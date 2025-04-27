#!/bin/bash

# Salir si algo falla
set -e

# Verificar la instalación de Docker
echo "Verificando si Docker está instalado..."
which docker || echo "Docker no está instalado. Procediendo con instalación."

# Instalar Docker si no está presente
if ! which docker > /dev/null 2>&1; then
  echo "Docker no está instalado, procediendo a instalar..."
  sudo amazon-linux-extras install docker -y
  sudo systemctl enable --now docker
fi

# Iniciar Docker si no está corriendo
sudo systemctl start docker

# Verificar que Docker está corriendo
sudo systemctl status docker

# Instalar Docker Compose si no está presente
if ! which docker-compose > /dev/null 2>&1; then
  echo "Docker Compose no está instalado, procediendo a instalar..."
  DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
  mkdir -p $DOCKER_CONFIG/cli-plugins
  curl -SL "https://github.com/docker/compose/releases/latest/download/docker-compose-linux-$(uname -m)" \
    -o $DOCKER_CONFIG/cli-plugins/docker-compose
  chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose

  # Crear enlace simbólico para acceso global
  sudo ln -s $DOCKER_CONFIG/cli-plugins/docker-compose /usr/local/bin/docker-compose
fi

# Verificar instalación de Docker y Docker Compose
which docker
docker --version
which docker-compose
docker-compose --version

# Ir al directorio del proyecto
cd /home/ec2-user/archivos-conf-script

# Ejecutar docker compose
docker compose up -d
