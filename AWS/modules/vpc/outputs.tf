############################################
# outputs.tf
############################################

output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnets" {
  value = aws_subnet.public[*].id
}

output "private_subnets" {
  value = aws_subnet.private[*].id
}

output "vpn_connection_id" {
  value       = var.enable_site_to_site_vpn ? aws_vpn_connection.this[0].id : null
  description = "VPN connection ID if enabled"
}
