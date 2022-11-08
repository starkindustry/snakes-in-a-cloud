resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_self_signed_cert" "certificate" {
  private_key_pem = tls_private_key.private_key.private_key_pem

  subject {
    common_name  = "snakesinacloud-starkindustry.com"
    organization = "Stark Industry Dev"
  }

  validity_period_hours = 24

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth"
  ]
}

resource "aws_acm_certificate" "self_signed_certificate" {
  private_key      = tls_private_key.private_key.private_key_pem
  certificate_body = tls_self_signed_cert.certificate.cert_pem
}
