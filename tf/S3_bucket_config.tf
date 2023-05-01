resource "aws_s3_bucket" "images_bucket" {
  bucket = var.bucket_name
  versioning {
        enabled = false
    }
  force_destroy = true
}
#resource "aws_s3_bucket_object" "src_folder" {
#  bucket = aws_s3_bucket.images_bucket.id
#  key    = "src-images/"
#}
#
#resource "aws_s3_bucket_object" "images_folder" {
#  bucket = aws_s3_bucket.images_bucket.id
#  key    = "Profesor/"
#}