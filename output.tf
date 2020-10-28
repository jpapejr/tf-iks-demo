output "manager_instance_ip" {
  value = ibm_is_floating_ip.fip.address
}

output "cluster_endpoint" {
  value = ibm_container_vpc_cluster.cluster.private_service_endpoint_url
}

output "clusterid" {
  value = ibm_container_vpc_cluster.cluster.id
}

output "private_key" {
    value = tls_private_key.privatekey.private_key_pem
}
