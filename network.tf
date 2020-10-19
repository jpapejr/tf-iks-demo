resource "ibm_is_vpc" "vpc" {
  name = "${var.project}-${var.environment}"
  resource_group = ibm_resource_group.group.id
  address_prefix_management = "manual"
  depends_on = [ ibm_resource_group.group ]

}

resource "ibm_is_vpc_address_prefix" "prefix1" {
  name = "${var.project}-${var.environment}-prefix1"
  vpc = ibm_is_vpc.vpc.id
  cidr = "172.26.0.0/24"
  zone = "us-east-1"
}

resource "ibm_is_vpc_address_prefix" "prefix2" {
  name = "${var.project}-${var.environment}-prefix2"
  vpc = ibm_is_vpc.vpc.id
  cidr = "172.26.1.0/24"
  zone = "us-east-2"
}

resource "ibm_is_subnet" "subnet1" {
  ipv4_cidr_block = "172.26.1.0/26"
  name = "${var.project}-${var.environment}-subnet1"
  vpc = ibm_is_vpc.vpc.id
  resource_group = ibm_resource_group.group.id
  zone = "us-east-1"
  depends_on = [ ibm_is_vpc_address_prefix.prefix1, ibm_resource_group.group ]
}

resource "ibm_is_subnet" "subnet2" {
  ipv4_cidr_block = "172.26.2.0/26"
  name = "${var.project}-${var.environment}-subnet2"
  vpc = ibm_is_vpc.vpc.id
  resource_group = ibm_resource_group.group.id
  zone = "us-east_2"
  depends_on = [ ibm_is_vpc_address_prefix.prefix2, ibm_resource_group.group ]
}

resource "ibm_is_public_gateway" "gw1" {
  name = "${var.project}-${var.environment}-pgw1"
  resource_group = ibm_resource_group.group.id
  vpc = ibm_is_vpc.vpc.id
  zone = "us-east-1"
  depends_on = [ ibm_is_vpc.vpc, ibm_resource_group.group ]
}

resource "ibm_is_public_gateway" "gw2" {
  name = "${var.project}-${var.environment}-pgw2"
  resource_group = ibm_resource_group.group.id
  vpc = ibm_is_vpc.vpc.id
  zone = "us-east-2"
  depends_on = [ ibm_is_vpc.vpc, ibm_resource_group.group ]
}

resource "ibm_is_floating_ip" "fip" {
  name = "${var.project}-${var.environment}-fip"
  resource_group = ibm_resource_group.group.id 
  target = ibm_is_instance.primary_network_interface[0].id
  depends_on = [ ibm_is_instance.inst1 ]
}

resource "ibm_is_security_group_rule" "rule1" {
  direction = "inbound"
  group = ibm_is_vpc.vpc.default_security_group
  remote = "0.0.0.0/0"
  tcp {
    port_min = 22
    port_max = 22
  }
  ip_version = "ipv4"
}

