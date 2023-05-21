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
public_ip=$(terraform output -raw public_ip)
bucket_name=$(terraform output -raw bucket_name)
s3_bucket_access_key=$(aws configure get aws_access_key_id)
s3_bucket_secret_key=$(aws configure get aws_secret_access_key)

# Verifica si la salida contiene el valor esperado del Public IPv4 DNS
if [ -z "$public_dns" ]; then
  echo "No se pudo extraer el Public IPv4 DNS de la instancia."
  exit -1
else
  echo "El Public IPv4 DNS de la instancia es: $public_dns"
fi
if [ -z "$public_ip" ]; then
  echo "No se pudo extraer el Public IPv4 de la instancia."
  exit -1
else
  echo "El Public IPv4 de la instancia es: $public_ip"
fi

cd ../ansible

echo "$s3_bucket_access_key:$s3_bucket_secret_key" > passwd-s3fs

echo "[ec2_instances]" > inventory
# Guarda el valor del Public IPv4 DNS en un archivo

ssh_direction=$(realpath ../tf/ssh/id_rsa)


echo "$public_dns ansible_user=ec2-user ansible_ssh_private_key_file=$ssh_direction" >> inventory
echo "El Public IPv4 DNS se ha guardado en el archivo 'inventory'."

echo $public_ip > ../ip_publica

cd ..

export ANSIBLE_HOST_KEY_CHECKING=False

ansible -i ansible/inventory -m ping ec2_instances

ansible-playbook -i ansible/inventory ansible/instalacion.yaml --extra-vars "bucket_name=$bucket_name"