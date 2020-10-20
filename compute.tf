resource "ibm_is_instance" "inst1" {
  name = "${var.project}-${var.environment}-inst1"
  primary_network_interface {
    name = "eth0"
    security_groups = [ ibm_is_vpc.vpc.default_security_group ]
    subnet = ibm_is_subnet.subnet1.id
  }
  keys = [ data.ibm_is_ssh_key.key.id ]
  resource_group = ibm_resource_group.group.id
  profile = "cx2-2x4"
  zone = "us-east-1"
  vpc = ibm_is_vpc.vpc.id
  image = "r014-ed3f775f-ad7e-4e37-ae62-7199b4988b00"
  user_data = file("${path.module}/bootstrap.sh")
  depends_on = [ ibm_is_vpc.vpc, ibm_is_subnet.subnet1, ibm_resource_group.group ]
}
