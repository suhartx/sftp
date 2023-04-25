# SFTP

## Requisitos

- Una cuenta de aws
- una maquina linux o usar wsl con cualquier maquina en wsl version 2 para que tenga una mayor compattibilidad con ansible

## Pasos

1. instalar aws cli
2. aws configure para establecer las credenciales de acceso 
3. instalar terraform
4. instalar ansible
5. ejecutar el script iniciacion.sh
6. ejecutar comando de terraform ansible-playbook -i ansible/inventory ansible/instalacion.yaml --extra-vars "@ansible/variables.yml"
7. revisar pasos de ansible y corregirlos para hacer lo mismo que en los scripts







NO ME DEJA ACCEDER AL SFTP SI NO TENGO UN USUARIO PRESTABLECIDO