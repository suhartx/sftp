#!/bin/bash


# Verifica si el usuario que ejecuta el script tiene permisos de root
if [ "$(id -u)" -ne 0 ]; then
  echo "Este script debe ser ejecutado con permisos de root." >&2
  exit 1
fi

# Verifica si se ingresó un nombre de usuario y contraseña como argumentos
if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Debe ingresar el nombre de usuario y la contraseña como argumentos." >&2
  exit 1
fi

# Define las variables de usuario y contraseña
USER=$1
PASS=$2

# Crea el usuario
useradd -G sftpgroup -d /mnt/s3/alumnos/$USER -s /sbin/nologin $USER

# Asigna la contraseña
echo "$PASS" | passwd --stdin $USER

# Crea los directorios y asigna permisos
mkdir -p /mnt/s3/alumnos/$USER
chown root:root /mnt/s3/alumnos/$USER
sudo chmod 755 /mnt/s3/alumnos/$USER

mkdir -p /mnt/s3/alumnos/$USER/escritura
mkdir -p /mnt/s3/alumnos/$USER/lectura
chown $USER:$USER /mnt/s3/alumnos/$USER/escritura
chown ec2-user:$USER /mnt/s3/alumnos/$USER/lectura

# Agrega el usuario al grupo sftpuser
usermod -a -G $USER ec2-user

# Elimina los archivos de configuración de Bash
rm -f /mnt/s3/alumnos/$USER/.bash_logout /mnt/s3/alumnos/$USER/.bash_profile /mnt/s3/alumnos/$USER/.bashrc
echo "Usuario $USER creado con éxito."
