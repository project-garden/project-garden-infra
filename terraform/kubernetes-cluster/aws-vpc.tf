// Create VPC for k8s cluster
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.2"

  name = "${local.cluster_name}-vpc"

  cidr = "10.0.0.0/16"
  azs  = slice(data.aws_availability_zones.available.names, 0, 3)

  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = 1
  }

  tags = {
      Environment = "development"
      Owner = "infrastructure"
      Created = local.timestamp
      Type = "vpc"
  }
}

// Additional subnet for data VM
resource "aws_subnet" "data_subnet" {
  cidr_block = "10.0.7.0/24"
  vpc_id     = module.vpc.vpc_id
  
  tags = {
    Name = "${local.cluster_name}-data-subnet"
    Environment = "development"
    Owner = "infrastructure"
    Created = local.timestamp
    Type = "vpc-subnet"
  }
}

// Create route table for data subnet that pointing to igw
resource "aws_route_table" "data_route_table" {
    vpc_id = module.vpc.vpc_id
    
    tags = {
      Name = "${local.cluster_name}-data-route-table"
      Environment = "development"
      Owner = "infrastructure"
      Created = local.timestamp
      Type = "route-table"
    }
}

// Create Route for data subnet 
resource "aws_route" "data_route" {
  route_table_id            = aws_route_table.data_route_table.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = module.vpc.igw_id
}

// Associate subnet data to route table
resource "aws_route_table_association" "data_association" {
  subnet_id      = aws_subnet.data_subnet.id
  route_table_id = aws_route_table.data_route_table.id
}