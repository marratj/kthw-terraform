output "kubelet_crt_files" {
  value = "${local_file.kubelet_crt.*.filename}"
}

output "kubelet_key_files" {
  value = "${local_file.kubelet_key.*.filename}"
}

output "kube-proxy_crt_file" {
  value = "${local_file.kube_proxy_crt.filename}"
}

output "kube-proxy_key_file" {
  value = "${local_file.kube_proxy_key.filename}"
}

output "kube_ca_crt_file" {
  value = "${local_file.kube_ca_crt.filename}"
}
