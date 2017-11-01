resource "tls_private_key" "kube_proxy" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "tls_cert_request" "kube_proxy" {
  key_algorithm   = "${tls_private_key.kube_proxy.algorithm}"
  private_key_pem = "${tls_private_key.kube_proxy.private_key_pem}"

  subject {
    common_name         = "system:kube-proxy"
    organization        = "system:node-proxier"
    country             = "US"
    locality            = "Portland"
    organizational_unit = "Kubernetes The Hard Way"
    province            = "Oregon"
  }
}

resource "tls_locally_signed_cert" "kube_proxy" {
  cert_request_pem   = "${tls_cert_request.kube_proxy.cert_request_pem}"
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

resource "local_file" "kube_proxy_key" {
  content  = "${tls_private_key.kube_proxy.private_key_pem}"
  filename = "./tls/kube-proxy-key.pem"
}

resource "local_file" "kube_proxy_crt" {
  content  = "${tls_locally_signed_cert.kube_proxy.cert_pem}"
  filename = "./tls/kube-proxy.pem"
}
