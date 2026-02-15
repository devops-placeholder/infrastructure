# Enterprise Reusable Terraform VPC + Site‑to‑Site VPN Module



############################################
# main.tf
############################################

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, {
    Name        = "${var.project}-${var.environment}-vpc"
    Environment = var.environment
    Project     = var.project
  })
}

############################################
# Internet Gateway
############################################

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = "${var.project}-${var.environment}-igw"
  })
}

############################################
# Public Subnets
############################################

resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name = "${var.project}-${var.environment}-public-${count.index + 1}"
  })
}

############################################
# Private Subnets
############################################

resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]

  tags = merge(var.tags, {
    Name = "${var.project}-${var.environment}-private-${count.index + 1}"
  })
}

############################################
# Route Tables
############################################

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

############################################
# NAT Gateway (per AZ pattern)
############################################

resource "aws_eip" "nat" {
  count = length(var.public_subnet_cidrs)
}

resource "aws_nat_gateway" "this" {
  count         = length(var.public_subnet_cidrs)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(var.tags, {
    Name = "${var.project}-${var.environment}-nat-${count.index + 1}"
  })
}

resource "aws_route_table" "private" {
  count  = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this[count.index].id
  }
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

############################################
# Site‑to‑Site VPN (Optional)
############################################

resource "aws_customer_gateway" "this" {
  count      = var.enable_site_to_site_vpn ? 1 : 0
  bgp_asn    = var.bgp_asn
  ip_address = var.customer_gateway_ip
  type       = "ipsec.1"
}

resource "aws_vpn_gateway" "this" {
  count  = var.enable_site_to_site_vpn ? 1 : 0
  vpc_id = aws_vpc.this.id
}

resource "aws_vpn_connection" "this" {
  count               = var.enable_site_to_site_vpn ? 1 : 0
  vpn_gateway_id      = aws_vpn_gateway.this[0].id
  customer_gateway_id = aws_customer_gateway.this[0].id
  type                = "ipsec.1"
  static_routes_only  = true
}

resource "aws_vpn_connection_route" "onprem" {
  count                  = var.enable_site_to_site_vpn ? 1 : 0
  vpn_connection_id      = aws_vpn_connection.this[0].id
  destination_cidr_block = var.onprem_cidr
}




