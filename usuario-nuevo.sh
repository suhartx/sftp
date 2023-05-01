echo  "Introduce el nombre de usuario: "
read usuario
echo  "Introduce la contraseña:"
read contrasenya
echo "-------------------"
echo "$usuario"
echo "$contrasenya"

ansible-playbook -i ansible/inventory ansible/usuario.yml  -e "username=$usuario password=$contrasenya"


