#!/bin/bash

# Actualizar el sistema
echo "Actualizando el sistema..."
sudo yum update -y

# Instalar Docker
echo "Instalando Docker..."
sudo amazon-linux-extras install docker -y
sudo systemctl enable --now docker

# Configurar el usuario docker sin sudo
sudo usermod -aG docker ec2-user

# Verificar si Docker está instalado
echo "Verificando Docker..."
if ! which docker > /dev/null 2>&1; then
  echo "Docker no está instalado. Procediendo con instalación..."
  sudo yum install docker -y
else
  echo "Docker ya está instalado."
fi

# Verificar si Docker Compose está instalado
echo "Verificando Docker Compose..."
if ! which docker-compose > /dev/null 2>&1; then
  echo "Docker Compose no está instalado, procediendo con instalación..."
  
  # Instalar Docker Compose v2 (última versión estable)
  DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
  mkdir -p $DOCKER_CONFIG/cli-plugins
  curl -SL "https://github.com/docker/compose/releases/latest/download/docker-compose-linux-$(uname -m)" \
    -o $DOCKER_CONFIG/cli-plugins/docker-compose
  chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose
  
  # Crear enlace simbólico para acceso global
  sudo ln -s $DOCKER_CONFIG/cli-plugins/docker-compose /usr/local/bin/docker-compose
else
  echo "Docker Compose ya está instalado."
fi

# Verificar si Docker y Docker Compose están disponibles
echo "=== Versiones instaladas ==="
docker --version
docker compose version

# Instalar dependencias útiles
echo "Instalando dependencias adicionales..."
sudo yum install -y git awscli

# Configurar Docker para usar overlay2
echo "Configurando Docker para usar el almacenamiento overlay2..."
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

# Reiniciar Docker para aplicar los cambios
sudo systemctl restart docker

# Verificar la instalación de Docker y Docker Compose
echo "Verificando instalaciones..."
docker --version
docker compose version
aws --version

echo "Instalación completada."

