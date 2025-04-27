#!/bin/bash

# Salir si algo falla
set -e

# Verificar Docker
echo "Docker version:"
docker -v

echo "Docker Compose version:"
docker compose version

# Ir al directorio del proyecto
cd /home/ec2-user/archivos-conf-script

# Ejecutar docker compose
docker compose up -d
