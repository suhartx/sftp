variable "region" {
  default = "eu-west-1"
}
variable "bucket_name" {
  default = "sftpbucketsuhar"
}
variable "ec2_key_name" {
 default = "id_rsa"
}
variable "ec2_public_key" {
 default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDjOK1jr06NM7LvFLlCibVJsIEBu6s3qtebG0iRlCotTcl6jZZX3xCSNW2RCM9DibtBxrBoyC3JieEB04LAV6TJKRLYjWx8iLjtVKJYq1hHqGS1JhfMKKP6gx6TBFCh546bUJURF4AdZUNDvZWc1v18XD+z+UZ1uY+5g0CHMzt5NFBYSal1Cl9F0I7c9x7A4lsBaXwITFi7trjeP+gnwvaXG48iXG025/B5Jp3QHX7RWt7F980F8di9mT+e6Q4bM7RmkVGgP32yG/QhgyRMOpTFpIH/yQ7sxxYfoNARHG3/sh+gisKmlMSlUTc/MYaQOAgPiEeghA2SEzixIR6apO0/O6GFf5P+7+1ajhICvaaM6Z+i25V5FeS6N9vYZs/hBm5Ca5wG0X32PJDvkeiV15KuBDTD4ivEdlMfL5ZyyJHdpgCRdiJ5BTjmEM2QdS9T97KUQN7go7Pm6CmjODxWskL8yrY0ZAXvEVsl+difn46wlLTNG2Y/WcsD3qYKgXfJ0CE= maita@LAPTOP-BPQS4KH4"
}
variable "ec2_private_key_file_path" {
 default = "ssh/id_rsa"
}