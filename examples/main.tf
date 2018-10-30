provider "aws" {
  region = "${var.region}"
}

# VPC Module provided by Terraform
# https://github.com/terraform-aws-modules/terraform-aws-vpc
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.name}"

  cidr = "10.0.0.0/16"

  azs             = ["us-west-1a", "us-west-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    Name = "${var.name}-${var.environment}-pub"
  }

  private_subnet_tags = {
    Name = "${var.name}-${var.environment}-priv"
  }

  tags = {
    Environment = "${var.environment}"
  }

  vpc_tags = {
    Name = "${var.name}-${var.environment}"
  }
}

# Module BTC
module "bitcoin_node" {
  source = "../"

  instance_count  = "${var.instance_count}"
  name            = "${var.name}-${var.environment}"
  ami             = "${var.ami}"
  instance_type   = "${var.instance_type}"
  vpc_id          = "${module.vpc.vpc_id}"
  cidr_blocks     = "${module.vpc.vpc_cidr_block}"
  subnet          = "${module.vpc.public_subnets[0]}"
  blockchain      = "${var.blockchain}"
  blockchain_port = "${var.blockchain_port}"
  testnet         = "${var.testnet}"
  size            = "${var.size}"
  ssh             = "${var.ssh}"
  ssh_key         = "${var.ssh_key}"
  user            = "${var.user}"
  pass            = "${var.pass}"
}
