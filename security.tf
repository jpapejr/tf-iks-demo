resource "tls_private_key" "privatekey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "ibm_is_ssh_key" "key" {
  name = "${var.project}-${var.environment}-key"
  resource_group = ibm_resource_group.group.id
  public_key = tls_private_key.privatekey.public_key_openssh
  depends_on = [tls_private_key.privatekey]
}
