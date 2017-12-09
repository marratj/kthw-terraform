resource "null_resource" "kubelet_configs" {
  count = "${length(var.kubelet_node_names)}"

  depends_on = ["module.pki"]

  provisioner "local-exec" {
    command = "kubectl config set-cluster kubernetes-the-hard-way --certificate-authority=tls/ca.pem --embed-certs=true --server=https://${var.apiserver_public_ip}:6443 --kubeconfig=${element(var.kubelet_node_names, count.index)}.kubeconfig"
  }
}
