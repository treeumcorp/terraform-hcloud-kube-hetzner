output "cluster_name" {
  value       = var.cluster_name
  description = "Shared suffix for all resources belonging to this cluster."
}

output "network_id" {
  value       = data.hcloud_network.k3s.id
  description = "The ID of the HCloud network."
}

output "ssh_key_id" {
  value       = local.hcloud_ssh_key_id
  description = "The ID of the HCloud SSH key."
}

output "control_planes_public_ipv4" {
  value = [
    for obj in module.control_planes : obj.ipv4_address
  ]
  description = "The public IPv4 addresses of the controlplane servers."
}

output "agents_public_ipv4" {
  value = [
    for obj in module.agents : obj.ipv4_address
  ]
  description = "The public IPv4 addresses of the agent servers."
}

output "ingress_public_ipv4" {
  description = "The public IPv4 address of the Hetzner load balancer"
  value       = local.has_external_load_balancer ? module.control_planes[keys(module.control_planes)[0]].ipv4_address : hcloud_load_balancer.cluster[0].ipv4
}

output "ingress_public_ipv6" {
  description = "The public IPv6 address of the Hetzner load balancer"
  value       = (local.has_external_load_balancer || var.load_balancer_disable_ipv6) ? null : hcloud_load_balancer.cluster[0].ipv6
}

output "k3s_endpoint" {
  description = "A controller endpoint to register new nodes"
  value       = "https://${var.use_control_plane_lb ? hcloud_load_balancer_network.control_plane.*.ip[0] : module.control_planes[keys(module.control_planes)[0]].private_ipv4_address}:6443"
}

output "k3s_token" {
  description = "The k3s token to register new nodes"
  value       = local.k3s_token
  sensitive   = true
}

output "control_plane_nodes" {
  description = "The control plane nodes"
  value       = [for node in module.control_planes : node]
}

output "agent_nodes" {
  description = "The agent nodes"
  value       = [for node in module.agents : node]
}

# Keeping for backward compatibility
output "kubeconfig_file" {
  value       = local.kubeconfig_external
  description = "Kubeconfig file content with external IP address"
  sensitive   = true
}

output "kubeconfig" {
  value       = local.kubeconfig_external
  description = "Kubeconfig file content with external IP address"
  sensitive   = true
}

output "kubeconfig_data" {
  description = "Structured kubeconfig data to supply to other providers"
  value       = local.kubeconfig_data
  sensitive   = true
}
