# Copy certificates to /var/lib/kubernetes
resource "null_resource" "kubernetes_certs" {
  count = "${length(var.apiserver_node_names)}"

  connection {
    type         = "ssh"
    user         = "${var.node_user}"
    host         = "${element(var.apiserver_node_names, count.index)}"
    bastion_host = "${var.apiserver_public_ip}"
  }

  provisioner "remote-exec" {
    inline = [
      "echo ${element(var.ca_cert_null_ids, count.index)}",
      "echo ${element(var.kubernetes_certs_null_ids, count.index)}",
      "sudo mkdir -p /var/lib/kubernetes/",
      "sudo mv ca.pem ca-key.pem kubernetes-key.pem kubernetes.pem service-account-key.pem service-account.pem encryption-config.yaml /var/lib/kubernetes/",
    ]
  }
}

# Download etcd binary
resource "null_resource" "kubernetes_binaries" {
  count = "${length(var.apiserver_node_names)}"

  connection {
    type         = "ssh"
    user         = "${var.node_user}"
    host         = "${element(var.apiserver_node_names, count.index)}"
    bastion_host = "${var.apiserver_public_ip}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /etc/kubernetes/config",
      "wget -q --show-progress --https-only --timestamping 'https://storage.googleapis.com/kubernetes-release/release/v1.12.0/bin/linux/amd64/kube-apiserver' 'https://storage.googleapis.com/kubernetes-release/release/v1.12.0/bin/linux/amd64/kube-controller-manager' 'https://storage.googleapis.com/kubernetes-release/release/v1.12.0/bin/linux/amd64/kube-scheduler' 'https://storage.googleapis.com/kubernetes-release/release/v1.12.0/bin/linux/amd64/kubectl'",
      "chmod +x kube-apiserver kube-controller-manager kube-scheduler kubectl",
      "sudo mv kube-apiserver kube-controller-manager kube-scheduler kubectl /usr/local/bin/",
    ]
  }
}

data "template_file" "apiserver_service_template" {
  template = "${file("${path.module}/kubernetes-apiserver.service.tpl")}"

  count = "${length(var.apiserver_private_ips)}"

  vars {
    INTERNAL_IP = "${element(var.apiserver_private_ips, count.index)}"
  }
}

resource "local_file" "apiserver_config" {
  count    = "${length(var.apiserver_private_ips)}"
  content  = "${data.template_file.apiserver_service_template.*.rendered[count.index]}"
  filename = "./generated/${element(var.apiserver_node_names, count.index)}.kubernetes-apiserver.service"
}

# Configure the etcd server
resource "null_resource" "kubernetes_apiserver" {
  count = "${length(var.apiserver_node_names)}"

  connection {
    type         = "ssh"
    user         = "${var.node_user}"
    host         = "${element(var.apiserver_node_names, count.index)}"
    bastion_host = "${var.apiserver_public_ip}"
  }

  depends_on = ["local_file.apiserver_config"]

  provisioner "file" {
    source      = "./generated/${element(var.apiserver_node_names, count.index)}.kubernetes-apiserver.service"
    destination = "~/${element(var.apiserver_node_names, count.index)}.kubernetes-apiserver.service"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv ~/${element(var.apiserver_node_names, count.index)}.kubernetes-apiserver.service /etc/systemd/system/kubernetes-apiserver.service",
      "sudo systemctl daemon-reload",
      "sudo systemctl enable kubernetes-apiserver",
      "sudo systemctl start kubernetes-apiserver",
      "kubectl get componentstatuses --kubeconfig admin.kubeconfig",
    ]
  }
}
