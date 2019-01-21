resource "random_string" "encryption_key" {
  length = 32
}

data "template_file" "encryption_config_template" {
  template = "${file("${path.module}/encryption_config.tpl")}"

  vars {
    encryption_key = "${base64encode(random_string.encryption_key.result)}"
  }
}

resource "local_file" "encryption_config" {
  content  = "${data.template_file.encryption_config_template.rendered}"
  filename = "./generated/encryption-config.yaml"
}

resource "null_resource" "encryption_config-provisioner" {
  count = "${length(var.apiserver_node_names)}"

  connection {
    type         = "ssh"
    user         = "${var.node_user}"
    host         = "${element(var.apiserver_node_names, count.index)}"
    bastion_host = "${var.apiserver_public_ip}"
  }

  provisioner "file" {
    source      = "./generated/encryption-config.yaml"
    destination = "~/encryption-config.yaml"
  }
}
