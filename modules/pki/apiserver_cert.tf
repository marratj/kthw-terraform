resource "tls_private_key" "apiserver" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "tls_cert_request" "apiserver" {
  key_algorithm   = "${tls_private_key.apiserver.algorithm}"
  private_key_pem = "${tls_private_key.apiserver.private_key_pem}"

  #ip_addresses = "${concat(var.apiserver_master_ips, var.apiserver_default_ips, list(data.template_file.public_ip.rendered))}"
  ip_addresses = [
    "${var.apiserver_master_ips}",
    "${var.apiserver_public_ip}",
    "127.0.0.1",
  ]

  subject {
    common_name         = "kubernetes"
    organization        = "Kubernetes"
    country             = "US"
    locality            = "Portland"
    organizational_unit = "Kubernetes The Hard Way"
    province            = "Oregon"
  }
}

resource "tls_locally_signed_cert" "apiserver" {
  cert_request_pem   = "${tls_cert_request.apiserver.cert_request_pem}"
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

resource "local_file" "apiserver_key" {
  content  = "${tls_private_key.apiserver.private_key_pem}"
  filename = "./tls/apiserver-key.pem"
}

resource "local_file" "apiserver_crt" {
  content  = "${tls_locally_signed_cert.apiserver.cert_pem}"
  filename = "./tls/apiserver.pem"
}
