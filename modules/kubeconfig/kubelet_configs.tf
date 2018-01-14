
data "template_file" "kubelet_config_template" {
  template = "${file("${path.module}/kubelet_config.tpl")}"

  count = "${var.kubelet_count}"

  vars {
    certificate-authority-data = "${base64encode(var.kube_ca_crt_pem)}"
    client-certificate-data = "${base64encode(element(var.kubelet_crt_pems, count.index))}"
    client-key-data = "${base64encode(element(var.kubelet_key_pems, count.index))}"
    apiserver_public_ip = "${var.apiserver_public_ip}"
    node_name = "${element(var.kubelet_node_names, count.index)}"
  }
}

resource "local_file" "kubelet_config" {

  count = "${length(var.kubelet_node_names)}"
  content  = "${data.template_file.kubelet_config_template.*.rendered[count.index]}"
  filename = "./generated/${element(var.kubelet_node_names, count.index)}.kubeconfig"
}

resource "null_resource" "kubelet-provisioner" {
  count = "${length(var.kubelet_node_names)}"

  connection {
    type         = "ssh"
    user         = "${var.node_user}"
    host         = "${element(var.kubelet_node_names, count.index)}"
    bastion_host = "${var.apiserver_public_ip}"
  }

  provisioner "file" {
    source      = "./generated/${element(var.kubelet_node_names, count.index)}.kubeconfig"
    destination = "~/${element(var.kubelet_node_names, count.index)}.kubeconfig"
  }
}
