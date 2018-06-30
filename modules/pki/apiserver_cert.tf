resource "tls_private_key" "kubernetes" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "tls_cert_request" "kubernetes" {
  key_algorithm   = "${tls_private_key.kubernetes.algorithm}"
  private_key_pem = "${tls_private_key.kubernetes.private_key_pem}"

  #ip_addresses = "${concat(var.kubernetes_master_ips, var.apiserver_default_ips, list(data.template_file.public_ip.rendered))}"
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

resource "tls_locally_signed_cert" "kubernetes" {
  cert_request_pem   = "${tls_cert_request.kubernetes.cert_request_pem}"
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

resource "local_file" "kubernetes_key" {
  content  = "${tls_private_key.kubernetes.private_key_pem}"
  filename = "./generated/tls/kubernetes-key.pem"
}

resource "local_file" "kubernetes_crt" {
  content  = "${tls_locally_signed_cert.kubernetes.cert_pem}"
  filename = "./generated/tls/kubernetes.pem"
}

resource "null_resource" "kubernetes_certs" {
  count = "${length(var.apiserver_node_names)}"

  connection {
    type         = "ssh"
    user         = "${var.node_user}"
    host         = "${element(var.apiserver_node_names, count.index)}"
    bastion_host = "${var.apiserver_public_ip}"
  }

  provisioner "file" {
    source      = "./generated/tls/kubernetes.pem"
    destination = "~/kubernetes.pem"
  }

  provisioner "file" {
    source      = "./generated/tls/kubernetes-key.pem"
    destination = "~/kubernetes-key.pem"
  }
}

resource "null_resource" "etcd_certs" {
  count = "${length(var.apiserver_node_names)}"

  connection {
    type         = "ssh"
    user         = "${var.node_user}"
    host         = "${element(var.apiserver_node_names, count.index)}"
    bastion_host = "${var.apiserver_public_ip}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /etc/etcd /var/lib/etcd",
      "sudo cp ca.pem kubernetes-key.pem kubernetes.pem /etc/etcd/",
    ]
  }
}
