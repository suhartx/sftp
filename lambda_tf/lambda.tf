resource "aws_iam_role" "sftp_role" {
  name               = "sftp_role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "sftp_policy" {
  name   = "sftp_policy"
  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Sid       = "VisualEditor0"
        Effect    = "Allow"
        Action    = [
          "s3:ReplicateObject",
          "s3:PutObject",
          "s3:GetObject",
          "logs:CreateLogStream",
          "s3:DeleteAccessPoint",
          "s3:DeleteObject",
          "s3:DeleteAccessPointForObjectLambda",
          "logs:CreateLogGroup",
          "logs:PutLogEvents"
        ]
        Resource  = [
          "arn:aws:s3:::sftpstoragesuhar/*",
          "arn:aws:logs:*:*:*"
        ]
      },
      {
        Sid       = "VisualEditor1"
        Effect    = "Allow"
        Action    = [
          "ses:SendEmail",
          "ses:SendRawEmail"
        ]
        Resource  = "*"
      }
    ]
  })

  policy_arn = aws_iam_role_policy.sftp_policy.arn
  role       = aws_iam_role.sftp_role.name
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "lambda.py"
  output_path = "lambda.zip"
}

resource "aws_lambda_function" "sftp_lambda" {
  function_name = "sftp_lambda"
  filename = "lambda.zip"
  role = aws_iam_role.sftp_role.arn
  #handler = "lambda_function.lambda_handler"
  runtime = "python3.7"
  handler  = "app.lambda_handler"
  layers = [
    aws_lambda_layer_version.sftp_layer.arn,
  ]
  
  
  
  
  }

  # (opcional) Configuración para crear un trigger de evento que active la función Lambda
  # Ejemplo: Crea un trigger de evento de S3
  event_source_token = aws_s3_bucket_notification.aws-lambda-trigger.arn
  event_source_type = "s3"
}


resource "aws_lambda_layer_version" "sftp_layer" {
  filename            = "prueba.zip"
  layer_name          = "sftp_python_packages"
  source_code_hash    = data.archive_file.reliability_lib.output_base64sha256
  compatible_runtimes = ["python3.7"]
}



resource "aws_s3_bucket_notification" "aws-lambda-trigger" {
  bucket = sftpstoragesuhar
  lambda_function {
    lambda_function_arn = aws_lambda_function.sftp_lambda.arn
    events              = ["s3:ObjectCreated:*"]

  }

#resource "aws_lambda_permission" "test" {
#  statement_id  = "AllowS3Invoke"
#  action        = "lambda:InvokeFunction"
#  function_name = aws_lambda_function.test_lambda.function_name
#  principal     = "s3.amazonaws.com"
#  source_arn    = "arn:aws:s3:::sftpstoragesuhar"
#}

#resource "aws_s3_bucket_notification" "s3_notification" {
#  bucket = aws_s3_bucket.sftps3mixer_bucket.id
#
#  # (opcional) Configuración para filtrar eventos específicos
#  # Ejemplo: Filtra solo eventos de creación de objetos con un prefijo específico
#  filter_prefix = "uploads/"
#  
#  # (opcional) Configuración para agregar eventos específicos a la cola de eventos de Lambda
#  # Ejemplo: Agrega eventos de creación de objetos y eventos de eliminación
#  lambda_function {
#    lambda_function_arn = aws_lambda_function.sftps3mixer_lambda.arn
#    events = [
#      "s3:ObjectCreated:*",
#      "s3:ObjectRemoved:*"
#    ]
#  }
#}
