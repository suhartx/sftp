#!/bin/bash


# Comprueba si la inicialización de Terraform se ha realizado
# Accedemos a la subcarpeta

cd ./tf

if [ ! -d ".terraform" ]; then
  echo "Iniciando Terraform..."
  terraform init
fi

# Aplica el archivo de configuración y extrae el valor del Public IPv4 DNS
echo "Aplicando archivo de configuración Terraform..."
terraform apply -auto-approve

public_dns=$(terraform output -raw public_dns)

# Verifica si la salida contiene el valor esperado del Public IPv4 DNS
if [ -z "$public_dns" ]; then
  echo "No se pudo extraer el Public IPv4 DNS de la instancia."
else
  echo "El Public IPv4 DNS de la instancia es: $public_dns"
  
  # Guarda el valor del Public IPv4 DNS en un archivo
  echo $public_dns > archivo.txt
  echo "El Public IPv4 DNS se ha guardado en el archivo 'archivo.txt'."
fi
