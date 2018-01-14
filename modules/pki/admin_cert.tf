resource "tls_private_key" "kube_admin" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "tls_cert_request" "kube_admin" {
  key_algorithm   = "${tls_private_key.kube_admin.algorithm}"
  private_key_pem = "${tls_private_key.kube_admin.private_key_pem}"

  subject {
    common_name         = "admin"
    organization        = "system:masters"
    country             = "US"
    locality            = "Portland"
    organizational_unit = "Kubernetes The Hard Way"
    province            = "Oregon"
  }
}

resource "tls_locally_signed_cert" "kube_admin" {
  cert_request_pem   = "${tls_cert_request.kube_admin.cert_request_pem}"
  ca_key_algorithm   = "${tls_private_key.kube_ca.algorithm}"
  ca_private_key_pem = "${tls_private_key.kube_ca.private_key_pem}"
  ca_cert_pem        = "${tls_self_signed_cert.kube_ca.cert_pem}"

  validity_period_hours = 8760

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "cert_signing",
    "client_auth",
    "server_auth",
  ]
}

resource "local_file" "kube_admin_key" {
  content  = "${tls_private_key.kube_admin.private_key_pem}"
  filename = "./generated/tls/admin-key.pem"
}

resource "local_file" "kube_admin_crt" {
  content  = "${tls_locally_signed_cert.kube_admin.cert_pem}"
  filename = "./generated/tls/admin.pem"
}
