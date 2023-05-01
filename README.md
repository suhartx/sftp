# Implantación de un sistema SFTP basado en Terraform y Ansible

Este documento describe los pasos necesarios para implantar un sistema SFTP (SSH File Transfer Protocol) utilizando Terraform y Ansible en un sistema basado en Linux, como una máquina Linux o WSL2.

## Prerrequisitos

Antes de comenzar, es necesario tener instalado Terraform y Ansible en el sistema donde se va a configurar el sistema SFTP. También es necesario tener credenciales de AWS para acceder a los recursos necesarios. Si no se dispone de ellas, se deben seguir los siguientes pasos:

1. Crear una cuenta en AWS (si no se dispone de ella).
2. Acceder al panel de IAM y crear un usuario con acceso a los recursos necesarios (por ejemplo, un usuario con acceso de lectura/escritura a S3).
3. Generar unas credenciales de seguridad (access key y secret access key) para el usuario creado.

Una vez se dispone de las credenciales de seguridad, se deben configurar en el sistema.

Para instalar y configurar la **AWS CLI** en tu máquina, sigue estos pasos:

1. Instalación de AWS CLI: Puedes encontrar los detalles de instalación en la [documentación oficial](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) de AWS CLI.

2. Configuración de credenciales: Una vez que tengas la AWS CLI instalada, puedes configurar tus credenciales siguiendo los siguientes pasos:

   - Ejecuta el siguiente comando en tu terminal para iniciar la configuración de tus credenciales:

     ```bash
     aws configure
     ```

   - A continuación, introduce tu clave de acceso de AWS y tu clave secreta de acceso.

   - Configura la región predeterminada en la que deseas trabajar.

   - Configura el formato de salida predeterminado que deseas utilizar (json).

## Configuración del archivo de variables

Antes de implantar el sistema SFTP, es necesario configurar el archivo `variables.tf` para indicar el nombre del bucket de S3 que se va a crear. Para ello, se puede editar el archivo y cambiar el valor de la variable `bucket_name`.

## Implantación del sistema SFTP

Para implantar el sistema SFTP, se deben seguir los siguientes pasos:

1. Clonar el repositorio de código y navegar hasta la carpeta `principal`.
2. crear un par de claves ssh y guardarlo en la carpeta ssh o usar las claves creadas por defecto.
3. Ejecutar el script `iniciacion.sh` para los archivos de configuración de terraform y ansible.

Una vez se hayan creado los recursos, las lineas de código indicaran el IPv4 que tendra la maquina que se ha montado, mediante ella y el fichero de clave secreta. podremos acceder a la maquina mediante ssh con el usuario `ec2-user`.



## Acceso al sistema SFTP

Una vez implantado el sistema SFTP, se podrá acceder a él mediante un cliente SFTP, como Filezilla o WinSCP.

Después de ejecutar el script, aparecerán las líneas de código que indicarán la dirección IPv4 asignada a la máquina que se ha montado. Utilizando la dirección IP y el archivo de clave secreta, se puede acceder a la máquina mediante SSH con el usuario `ec2-user`.

```bash
ssh -i /tf/ssh/id_rsa ec2-user@<IP address>
```

También es posible acceder al sistema utilizando el usuario `sftpuser`, el cual tendrá acceso restringido a su carpeta personal, o con el usuario `ec2-user`, que tendrá acceso a todas las carpetas de los usuarios.

Además, es posible crear más usuarios ejecutando el script `usuario-nuevo.sh`, que solicitará un nombre de usuario y una contraseña para el nuevo usuario. Finalmente, para destruir la infraestructura montada, se puede ejecutar el script `destruccion.sh`.



## Destrucción de la infraestructura

Para destruir toda la infraestructura creada con Terraform, se puede ejecutar el script `destruccion.sh`. Este borrará todos los recursos creados en AWS. Es importante tener en cuenta que una vez que se ejecute este script, no se podrá recuperar la infraestructura eliminada.

