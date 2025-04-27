#!/bin/bash

# Salir si algo falla
set -e

# Mostrar el PATH para depurar
echo "PATH: $PATH"

# Verificar si Docker está disponible
which docker
docker --version

# Verificar si Docker Compose está disponible
which docker-compose
docker-compose --version

# Ir al directorio del proyecto
cd /home/ec2-user/archivos-conf-script

# Ejecutar docker compose
docker-compose up -d
