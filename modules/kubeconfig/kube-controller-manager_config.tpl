apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: ${certificate-authority-data}
    server: https://${apiserver_public_ip}:6443
  name: kubernetes-the-hard-way
contexts:
- context:
    cluster: kubernetes-the-hard-way
    user: kube-proxy
  name: default
current-context: default
kind: Config
preferences: {}
users:
- name: kube-proxy
  user:
    as-user-extra: {}
    client-certificate-data: ${client-certificate-data}
    client-key-data: ${client-key-data}
