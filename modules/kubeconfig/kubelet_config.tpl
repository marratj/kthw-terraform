apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: ${certificate-authority-data}
    server: https://${apiserver_public_ip}:6443
  name: kubernetes-the-hard-way
contexts:
- context:
    cluster: kubernetes-the-hard-way
    user: system:node:${node_name}
  name: default
current-context: default
kind: Config
preferences: {}
users:
- name: system:node:${node_name}
  user:
    as-user-extra: {}
    client-certificate-data: ${client-certificate-data}
    client-key-data: ${client-key-data}
