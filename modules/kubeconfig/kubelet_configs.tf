resource "null_resource" "kubelet_configs" {
  count = "${length(var.kubelet_node_names)}"

  depends_on = ["module.pki"]

  provisioner "local-exec" {
    command = "kubectl config set-cluster kubernetes-the-hard-way --certificate-authority=tls/ca.pem --embed-certs=true --server=https://${var.apiserver_public_ip}:6443 --kubeconfig=${element(var.kubelet_node_names, count.index)}.kubeconfig"
  }

  provisioner "local-exec" {
    command = "kubectl config set-credentials system:node:${element(var.kubelet_node_names, count.index)} --client-certificate=${element(var.kubelet_node_names, count.index)}.pem --client-key=${element(var.kubelet_node_names, count.index)}-key.pem --embed-certs=true --kubeconfig=${element(var.kubelet_node_names, count.index)}.kubeconfig"
  }

  provisioner "local-exec" {
    command = "kubectl config set-context default --cluster=kubernetes-the-hard-way --user=system:node:${element(var.kubelet_node_names, count.index)} --kubeconfig=${element(var.kubelet_node_names, count.index)}.kubeconfig"
  }

  provisioner "local-exec" {
    command = "kubectl config use-context default --kubeconfig=${element(var.kubelet_node_names, count.index)}.kubeconfig"
  }
}
