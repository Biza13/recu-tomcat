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

# Instalando Apache (httpd)
echo "Instalando Apache (httpd)..."
sudo yum install -y httpd

# Habilitar e iniciar Apache
sudo systemctl enable --now httpd
echo "Apache (httpd) instalado y en funcionamiento."

# Verificación de los servicios
echo "Verificando el estado de Docker..."
sudo systemctl status docker --no-pager

echo "Verificando el estado de Apache..."
sudo systemctl status httpd --no-pager
