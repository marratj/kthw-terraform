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
