output "kubelet_crt_files" {
  value = "${local_file.kubelet_crt.*.filename}"
}

output "kubelet_key_files" {
  value = "${local_file.kubelet_key.*.filename}"
}

output "kubelet_crt_pems" {
  value = "${tls_locally_signed_cert.kubelet.*.cert_pem}"
}

output "kubelet_key_pems" {
  value = "${tls_private_key.kubelet.*.private_key_pem}"
}


output "kube-proxy_crt_file" {
  value = "${local_file.kube_proxy_crt.filename}"
}

output "kube-proxy_key_file" {
  value = "${local_file.kube_proxy_key.filename}"
}

output "kube-proxy_crt_pem" {
  value = "${tls_locally_signed_cert.kube_proxy.cert_pem}"
}

output "kube-proxy_key_pem" {
  value = "${tls_private_key.kube_proxy.private_key_pem}"
}

output "kube_ca_crt_file" {
  value = "${local_file.kube_ca_crt.filename}"
}

output "kube_ca_crt_pem" {
  value = "${tls_self_signed_cert.kube_ca.cert_pem}"
}