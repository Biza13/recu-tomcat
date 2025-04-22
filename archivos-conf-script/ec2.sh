#!/bin/bash

# Actualizar los paquetes del sistema
sudo yum -y update

# Instalar Docker usando amazon-linux-extras
echo "Instalando Docker en Amazon Linux 2..."
sudo amazon-linux-extras install docker -y

# Iniciar e habilitar el servicio Docker
sudo systemctl enable --now docker
echo "Docker instalado y en funcionamiento."

# Añadir ec2-user al grupo docker para usar Docker sin sudo
sudo usermod -aG docker ec2-user

# Verificación de los servicios
sudo systemctl status docker --no-pager

# Instalar Docker Compose
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose

# Establecer permisos de ejecución para docker-compose
sudo chmod +x /usr/local/bin/docker-compose

sleep 30