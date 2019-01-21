# Copy certificates to etcd config directory
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
      "echo ${element(var.ca_cert_null_ids, count.index)}",
      "echo ${element(var.kubernetes_certs_null_ids, count.index)}",
      "sudo mkdir -p /etc/etcd /var/lib/etcd",
      "sudo cp ca.pem kubernetes-key.pem kubernetes.pem /etc/etcd/",
    ]
  }
}

# Download etcd binary
resource "null_resource" "etcd_binary" {
  count = "${length(var.apiserver_node_names)}"

  connection {
    type         = "ssh"
    user         = "${var.node_user}"
    host         = "${element(var.apiserver_node_names, count.index)}"
    bastion_host = "${var.apiserver_public_ip}"
  }

  provisioner "remote-exec" {
    inline = [
      "wget -q --show-progress --https-only --timestamping 'https://github.com/coreos/etcd/releases/download/v3.3.9/etcd-v3.3.9-linux-amd64.tar.gz'",
      "tar -xvf etcd-v3.3.9-linux-amd64.tar.gz",
      "sudo mv etcd-v3.3.9-linux-amd64/etcd* /usr/local/bin/",
    ]
  }
}

data "template_file" "etcd_service_template" {
  template = "${file("${path.module}/etcd.service.tpl")}"

  count = "${length(var.apiserver_private_ips)}"

  vars {
    ETCD_NAME   = "${element(var.apiserver_node_names, count.index)}"
    INTERNAL_IP = "${element(var.apiserver_private_ips, count.index)}"
  }
}

resource "local_file" "etcd_config" {
  count    = "${length(var.apiserver_private_ips)}"
  content  = "${data.template_file.etcd_service_template.*.rendered[count.index]}"
  filename = "./generated/${element(var.apiserver_node_names, count.index)}.etcd.service"
}

# Configure the etcd server
resource "null_resource" "etcd_server" {
  count = "${length(var.apiserver_node_names)}"

  connection {
    type         = "ssh"
    user         = "${var.node_user}"
    host         = "${element(var.apiserver_node_names, count.index)}"
    bastion_host = "${var.apiserver_public_ip}"
  }

  depends_on = ["local_file.etcd_config"]

  provisioner "file" {
    source      = "./generated/${element(var.apiserver_node_names, count.index)}.etcd.service"
    destination = "~/${element(var.apiserver_node_names, count.index)}.etcd.service"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv ~/${element(var.apiserver_node_names, count.index)}.etcd.service /etc/systemd/system/etcd.service",
      "sudo systemctl daemon-reload",
      "sudo systemctl enable etcd",
      "sudo systemctl start etcd",
    ]
  }
}
