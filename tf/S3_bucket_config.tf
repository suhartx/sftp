resource "aws_s3_bucket" "images_bucket" {
  bucket = var.bucket_name

  force_destroy = true
}
resource "aws_s3_bucket_object" "profesor" {
  bucket = aws_s3_bucket.images_bucket.id
  key    = "profesor/"
}