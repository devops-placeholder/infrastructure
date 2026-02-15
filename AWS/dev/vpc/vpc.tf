module "enterprise_vpc" {
  source      = "../modules/vpc_with_vpn"
  project     = var.project
  environment = var.environment
  vpc_cidr    = var.vpc_cidr

  azs = var.azs

  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs

  enable_site_to_site_vpn = var.enable_site_to_site_vpn
  customer_gateway_ip     = var.customer_gateway_ip
  onprem_cidr             = var.onprem_cidr
}