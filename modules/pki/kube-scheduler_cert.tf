resource "tls_private_key" "kube_scheduler" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "tls_cert_request" "kube_scheduler" {
  key_algorithm   = "${tls_private_key.kube_scheduler.algorithm}"
  private_key_pem = "${tls_private_key.kube_scheduler.private_key_pem}"

  subject {
    common_name         = "system:kube-scheduler"
    organization        = "system:kube-scheduler"
    country             = "US"
    locality            = "Portland"
    organizational_unit = "Kubernetes The Hard Way"
    province            = "Oregon"
  }
}

resource "tls_locally_signed_cert" "kube_scheduler" {
  cert_request_pem   = "${tls_cert_request.kube_scheduler.cert_request_pem}"
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

resource "local_file" "kube_scheduler_key" {
  content  = "${tls_private_key.kube_scheduler.private_key_pem}"
  filename = "./generated/tls/kube-scheduler-key.pem"
}

resource "local_file" "kube_scheduler_crt" {
  content  = "${tls_locally_signed_cert.kube_scheduler.cert_pem}"
  filename = "./generated/tls/kube-scheduler.pem"
}
