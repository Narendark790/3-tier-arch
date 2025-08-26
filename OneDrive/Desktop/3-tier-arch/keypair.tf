# Key Pair

# Create a new RSA private key
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create a new local file to store the private key
resource "local_file" "key" {
  filename = "goutm.pem"
  content  = tls_private_key.rsa.private_key_pem
}

resource "aws_key_pair" "kp" {
  public_key = tls_private_key.rsa.public_key_openssh
  key_name   = "goutm"
}
