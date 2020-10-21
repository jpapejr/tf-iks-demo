resource "ibm_container_vpc_cluster" "cluster" {
  cos_instance_crn                = var.usecos ? ibm_resource_instance.cos_instance[0].id : ""
  disable_public_service_endpoint = true
  flavor                          = "bx2.4x16"
  name                            = "${var.project}-${var.environment}-cluster"
  kube_version                    = var.k8s_version
  resource_group_id               = ibm_resource_group.group.id
  vpc_id                          = ibm_is_vpc.vpc.id
  worker_count                    = 2
  wait_till                       = "OneWorkerNodeReady"
  force_delete_storage            = "true"
  zones {
    name      = "us-east-1"
    subnet_id = ibm_is_subnet.subnet1.id
  }
}

resource "ibm_container_vpc_worker_pool" "default-z2" {
  cluster           = ibm_container_vpc_cluster.cluster.id
  flavor            = "bx2.4x16"
  vpc_id            = ibm_is_vpc.vpc.id
  worker_count      = 2
  resource_group_id = ibm_resource_group.group.id
  worker_pool_name  = "us-east-2"
  zones {
    name      = "us-east-2"
    subnet_id = ibm_is_subnet.subnet2.id
  }
}
