resource "ibm_resource_group" "group" {
  name = "${var.project}-${var.environment}"
}

resource "ibm_resource_instance" "cos_instance" {
  count             = var.usecos
  name              = "${var.project}-${var.environment}-ocp_cos_instance"
  service           = "cloud-object-storage"
  plan              = "standard"
  resource_group_id = ibm_resource_group.group.id
  location          = "global"
}
