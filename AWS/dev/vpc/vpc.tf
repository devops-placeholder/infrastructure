module "enterprise_vpc" {
  source      = "./modules/vpc"
  project     = "payments"
  environment = "prod"
  vpc_cidr    = "10.10.0.0/16"

  azs = ["ap-south-1a", "ap-south-1b"]

  public_subnet_cidrs  = ["10.10.1.0/24", "10.10.2.0/24"]
  private_subnet_cidrs = ["10.10.10.0/24", "10.10.20.0/24"]

  enable_site_to_site_vpn = true
  customer_gateway_ip     = "1.2.3.4"
  onprem_cidr             = "192.168.0.0/16"
}