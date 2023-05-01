output "public_dns" {
  value = aws_instance.ec2_sftp_server.public_dns
}
output "public_ip" {
  value = aws_instance.ec2_sftp_server.public_ip
}
output "bucket_name" {
  value = aws_s3_bucket.images_bucket.bucket
}