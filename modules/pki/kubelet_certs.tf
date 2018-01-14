resource "tls_private_key" "kubelet" {
  count = "${length(var.kubelet_node_names)}"

  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "tls_cert_request" "kubelet" {
  key_algorithm   = "${tls_private_key.kubelet.*.algorithm[count.index]}"
  private_key_pem = "${tls_private_key.kubelet.*.private_key_pem[count.index]}"

  count = "${length(var.kubelet_node_names)}"

  lifecycle {
    ignore_changes = ["id"]
  }

  ip_addresses = [
    "${element(var.kubelet_node_ips, count.index)}",
  ]

  subject {
    common_name         = "system:node:${element(var.kubelet_node_names, count.index)}"
    organization        = "system:nodes"
    country             = "US"
    locality            = "Portland"
    organizational_unit = "Kubernetes The Hard Way"
    province            = "Oregon"
  }
}

resource "tls_locally_signed_cert" "kubelet" {
  count = "${length(var.kubelet_node_names)}"

  cert_request_pem   = "${tls_cert_request.kubelet.*.cert_request_pem[count.index]}"
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

resource "local_file" "kubelet_key" {
  count = "${length(var.kubelet_node_names)}"

  content  = "${tls_private_key.kubelet.*.private_key_pem[count.index]}"
  filename = "./generated/tls/kubelet/${element(var.kubelet_node_names, count.index)}-key.pem"
}

resource "local_file" "kubelet_crt" {
  count = "${length(var.kubelet_node_names)}"

  content  = "${tls_locally_signed_cert.kubelet.*.cert_pem[count.index]}"
  filename = "./generated/tls/kubelet/${element(var.kubelet_node_names, count.index)}.pem"
}

resource "null_resource" "kubelet_certs" {
  count = "${length(var.kubelet_node_names)}"

  depends_on = ["local_file.kubelet_crt"]

  connection {
    type         = "ssh"
    user         = "${var.node_user}"
    host         = "${element(var.kubelet_node_names, count.index)}"
    bastion_host = "${var.apiserver_public_ip}"
  }

  provisioner "file" {
    source      = "./generated/tls/kubelet/${element(var.kubelet_node_names, count.index)}.pem"
    destination = "~/${element(var.kubelet_node_names, count.index)}.pem"
  }

  provisioner "file" {
    source      = "./generated/tls/kubelet/${element(var.kubelet_node_names, count.index)}-key.pem"
    destination = "~/${element(var.kubelet_node_names, count.index)}-key.pem"
  }
}

resource "null_resource" "worker_ca_cert" {
  count = "${length(var.kubelet_node_names)}"

  depends_on = ["local_file.kube_ca_crt"]

  connection {
    type         = "ssh"
    user         = "${var.node_user}"
    host         = "${element(var.kubelet_node_names, count.index)}"
    bastion_host = "${var.apiserver_public_ip}"
  }

  provisioner "file" {
    source      = "./generated/tls/ca.pem"
    destination = "~/ca.pem"
  }
  
}
