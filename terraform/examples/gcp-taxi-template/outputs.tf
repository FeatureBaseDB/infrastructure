output "agent_private_ip" {
  value = "${module.agent.private_ip}"
}

output "agent_public_ip" {
  value = "${module.agent.public_ip}"
}

output "pilosa_private_ips" {
  value = "${module.pilosa.pilosa_private_ips}"
}

output "pilosa_public_ips" {
  value = "${module.pilosa.pilosa_public_ips}"
}
