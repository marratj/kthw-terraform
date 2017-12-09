resource "null_resource" "kubelet_configs" {
  count = "${length(var.kubelet_node_names)}"

  provisioner "local-exec" {
    command = "kubectl config set-cluster kubernetes-the-hard-way --certificate-authority=${var.ca_crt_file} --embed-certs=true --server=https://${var.apiserver_public_ip}:6443 --kubeconfig=./generated/${element(var.kubelet_node_names, count.index)}.kubeconfig"
  }

  provisioner "local-exec" {
    command = "kubectl config set-credentials system:node:${element(var.kubelet_node_names, count.index)} --client-certificate=${element(var.kubelet_crt_files, count.index)} --client-key=${element(var.kubelet_key_files, count.index)} --embed-certs=true --kubeconfig=./generated/${element(var.kubelet_node_names, count.index)}.kubeconfig"
  }

  provisioner "local-exec" {
    command = "kubectl config set-context default --cluster=kubernetes-the-hard-way --user=system:node:${element(var.kubelet_node_names, count.index)} --kubeconfig=./generated/${element(var.kubelet_node_names, count.index)}.kubeconfig"
  }

  provisioner "local-exec" {
    command = "kubectl config use-context default --kubeconfig=./generated/${element(var.kubelet_node_names, count.index)}.kubeconfig"
  }

  connection {
    type         = "ssh"
    user         = "${var.node_user}"
    host         = "${element(var.kubelet_node_names, count.index)}"
    bastion_host = "${var.apiserver_public_ip}"
  }

  provisioner "file" {
    source      = "generated/${element(var.kubelet_node_names, count.index)}.kubeconfig"
    destination = "~/${element(var.kubelet_node_names, count.index)}.kubeconfig"
  }
}
