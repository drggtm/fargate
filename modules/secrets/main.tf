resource "random_password" "app" {
  length  = 32
  special = true
}

resource "aws_secretsmanager_secret" "main" {
  name                    = var.secret_name
  description             = var.secret_description
  recovery_window_in_days = 7
}

resource "aws_secretsmanager_secret_version" "main" {
  secret_id = aws_secretsmanager_secret.main.id
  secret_string = jsonencode({
    username = "app"
    password = random_password.app.result
  })
}
