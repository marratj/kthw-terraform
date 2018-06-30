data "template_file" "kube-controller-manager_config_template" {
  template = "${file("${path.module}/kube-controller-manager_config.tpl")}"

  vars {
    certificate-authority-data = "${base64encode(var.kube_ca_crt_pem)}"
    client-certificate-data    = "${base64encode(var.kube-controller-manager_crt_pem)}"
    client-key-data            = "${base64encode(var.kube-controller-manager_key_pem)}"
    apiserver_public_ip        = "${var.apiserver_public_ip}"
  }
}

resource "local_file" "kube-controller-manager_config" {
  content  = "${data.template_file.kube-controller-manager_config_template.rendered}"
  filename = "./generated/kube-controller-manager.kubeconfig"
}

resource "null_resource" "kube-controller-manager-provisioner" {
  count = "${length(var.apiserver_node_names)}"

  depends_on = ["local_file.kube-controller-manager_config"]

  connection {
    type         = "ssh"
    user         = "${var.node_user}"
    host         = "${element(var.apiserver_node_names, count.index)}"
    bastion_host = "${var.apiserver_public_ip}"
  }

  provisioner "file" {
    source      = "./generated/kube-controller-manager.kubeconfig"
    destination = "~/kube-controller-manager.kubeconfig"
  }
}
