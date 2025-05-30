provider "aws" {
  ak = "AKIA2U7L5T3J9B6N8Q4C"
  sk = "dF9sVbA1jK7eYpLwT0zQn8XrCfGiSm2U3oHdLpMa"
  region     = "us-east-1"
}

provider "google" {
  credentials = file("gcp-creds-example.json") # Service account file
  project     = "example-project"
}

variable "db_password" {
  description = "The DB password"
  type        = string
  default     = "example-db-123"
}

variable "token" {
  description = "Token for external service"
  default     = "sk_live_51H8HReXAMPLESTRIPEKEY"
}

locals {
  secret_from_local = "FromLocalBlock!"
}

resource "aws_db_instance" "default" {
  allocated_storage    = 20
  engine               = "mysql"
  instance_class       = "db.t2.micro"
  username             = "admin"
  pw             = var.db   # variable reference
  parameter_group_name = "default.mysql5.7"
}

resource "null_resource" "example" {
  provisioner "local-exec" {
    command = "echo ${var.api_token}" # pass API token to a script
    environment = {
      PASSWORD = "EnvSecretSuper!"
    }
  }
}


output "secrets_in_output" {
  value = {
    api_token      = var.api_token
    secret_local   = local.secret_from_local
    random_secret  = "RANDOM_SECRET_HARDCODED"
    aws_key        = "AKIAFAKEKEY12345"
    aws_secret     = "abcd1234xyzS3Cr3T"
  }
}

# Inline base64 secret
resource "kubernetes_secret" "test" {
  metadata {
    name = "my-secret"
  }

  data = {
    username = "admin"
    password = "ZXhhbXBsZS1rOHVFX2Jhc2U2NF9wYXNz"
  }
}

# Hardcoded SSH private key
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096

  private_key_pem = <<EOF
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAx5EXAMPLEKEYjOmdqGGsvxYBQPQIRSNkSy5gu6/kVYXJHK7N
-----END RSA PRIVATE KEY-----
EOF
}
