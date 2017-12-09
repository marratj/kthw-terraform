resource "null_resource" "kube-proxy_config" {
  count = "${length(var.kubelet_node_names)}"

  provisioner "local-exec" {
    command = "kubectl config set-cluster kubernetes-the-hard-way --certificate-authority=${var.ca_crt_file} --embed-certs=true --server=https://${var.apiserver_public_ip}:6443 --kubeconfig=./generated/kube-proxy.kubeconfig"
  }

  provisioner "local-exec" {
    command = "kubectl config set-credentials kube-proxy --client-certificate=${var.kube-proxy_crt_file} --client-key=${var.kube-proxy_key_file} --embed-certs=true --kubeconfig=./generated/kube-proxy.kubeconfig"
  }

  provisioner "local-exec" {
    command = "kubectl config set-context default --cluster=kubernetes-the-hard-way --user=kube-proxy --kubeconfig=./generated/kube-proxy.kubeconfig"
  }

  provisioner "local-exec" {
    command = "kubectl config use-context default --kubeconfig=./generated/kube-proxy.kubeconfig"
  }

  connection {
    type         = "ssh"
    user         = "${var.node_user}"
    host         = "${element(var.kubelet_node_names, count.index)}"
    bastion_host = "${var.apiserver_public_ip}"
  }

  provisioner "file" {
    source      = "./generated/kube-proxy.kubeconfig"
    destination = "~/kube-proxy.kubeconfig"
  }
}
