resource "tls_private_key" "service-account" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "tls_cert_request" "service-account" {
  key_algorithm   = "${tls_private_key.service-account.algorithm}"
  private_key_pem = "${tls_private_key.service-account.private_key_pem}"

  #ip_addresses = "${concat(var.service-account_master_ips, var.apiserver_default_ips, list(data.template_file.public_ip.rendered))}"
  ip_addresses = [
    "${var.apiserver_master_ips}",
    "${var.apiserver_public_ip}",
    "127.0.0.1",
  ]

  subject {
    common_name         = "service-account"
    organization        = "service-account"
    country             = "US"
    locality            = "Portland"
    organizational_unit = "service-account The Hard Way"
    province            = "Oregon"
  }
}

resource "tls_locally_signed_cert" "service-account" {
  cert_request_pem   = "${tls_cert_request.service-account.cert_request_pem}"
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

resource "local_file" "service-account_key" {
  content  = "${tls_private_key.service-account.private_key_pem}"
  filename = "./generated/tls/service-account-key.pem"
}

resource "local_file" "service-account_crt" {
  content  = "${tls_locally_signed_cert.service-account.cert_pem}"
  filename = "./generated/tls/service-account.pem"
}

resource "null_resource" "service-account_certs" {
  count = "${length(var.apiserver_node_names)}"

  connection {
    type         = "ssh"
    user         = "${var.node_user}"
    host         = "${element(var.apiserver_node_names, count.index)}"
    bastion_host = "${var.apiserver_public_ip}"
  }

  provisioner "file" {
    source      = "./generated/tls/service-account.pem"
    destination = "~/service-account.pem"
  }

  provisioner "file" {
    source      = "./generated/tls/service-account-key.pem"
    destination = "~/service-account-key.pem"
  }
}
