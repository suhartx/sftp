# Configuración básica del proveedor AWS
provider "aws" {
  region = "us-west-2"
}

# Creación de una instancia EC2
resource "aws_instance" "sftp_server" {
  ami           = "ami-0c55b159cbfafe1f0" # AMI de Amazon Linux 2
  instance_type = "t2.micro"
  key_name      = "my_key_pair"

  tags = {
    Name = "SFTP Server Instance"
  }
}

# Configuración de OpenSSH para SFTP
resource "null_resource" "sftp_config" {
  depends_on = [aws_instance.sftp_server]

  # Instalación de OpenSSH en la instancia
  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y openssh-server",
      "sudo systemctl start sshd.service",
      "sudo systemctl enable sshd.service"
    ]

    connection {
      type        = "ssh"
      host        = aws_instance.sftp_server.public_ip
      user        = "ec2-user"
      private_key = file("path/to/my_key_pair.pem")
    }
  }

  # Configuración de OpenSSH para SFTP
  provisioner "remote-exec" {
    inline = [
      "sudo echo 'Match User sftpuser' >> /etc/ssh/sshd_config",
      "sudo echo 'ForceCommand internal-sftp' >> /etc/ssh/sshd_config",
      "sudo echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config",
      "sudo echo 'ChrootDirectory /home/sftpuser' >> /etc/ssh/sshd_config"
    ]

    connection {
      type        = "ssh"
      host        = aws_instance.sftp_server.public_ip
      user        = "ec2-user"
      private_key = file("path/to/my_key_pair.pem")
    }
  }

  # Creación de un usuario SFTP
  provisioner "remote-exec" {
    inline = [
      "sudo useradd sftpuser",
      "sudo mkdir /home/sftpuser",
      "sudo chown sftpuser:sftpuser /home/sftpuser",
      "sudo chmod 755 /home/sftpuser",
      "sudo passwd -d sftpuser",
      "sudo usermod -s /bin/false sftpuser"
    ]

    connection {
      type        = "ssh"
      host        = aws_instance.sftp_server.public_ip
      user        = "ec2-user"
      private_key = file("path/to/my_key_pair.pem")
    }
  }
}
