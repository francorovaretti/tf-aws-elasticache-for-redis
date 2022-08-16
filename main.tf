locals {
  name   = "aluminum-dev-vpc"
  region = "us-east-1"
  tags = {
    Owner       = "user"
    Environment = "development"
    Name        = "aluminum-dev-vpc"
  }
}

variable "main_region" {
  type    = string
  default = "us-east-1"
}

provider "aws" {
  region = var.main_region
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.2"

  name = local.name
  cidr = "20.10.0.0/16"

  azs                 = ["${var.main_region}a", "${var.main_region}b", "${var.main_region}c"]
  private_subnets     = ["20.10.1.0/24", "20.10.2.0/24", "20.10.3.0/24"]
  public_subnets      = ["20.10.11.0/24", "20.10.12.0/24", "20.10.13.0/24"]
  database_subnets    = ["20.10.21.0/24", "20.10.22.0/24", "20.10.23.0/24"]
  elasticache_subnets = ["20.10.31.0/24", "20.10.32.0/24", "20.10.33.0/24"]
  #   redshift_subnets    = ["20.10.41.0/24", "20.10.42.0/24", "20.10.43.0/24"]
  #   intra_subnets       = ["20.10.51.0/24", "20.10.52.0/24", "20.10.53.0/24"]

  create_database_subnet_group = false

  manage_default_network_acl = true
  default_network_acl_tags   = { Name = "${local.name}-default" }

  manage_default_route_table = true
  default_route_table_tags   = { Name = "${local.name}-default" }

  manage_default_security_group = true
  default_security_group_tags   = { Name = "${local.name}-default" }

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = true
  single_nat_gateway = true

  enable_dhcp_options = true

  tags = local.tags
}

module "redis" {
  source  = "./modules/elasticache-redis"
  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.elasticache_subnets
  enabled = true
  # region             = var.main_region
  availability_zones = ["${var.main_region}a", "${var.main_region}b", "${var.main_region}c"]
  namespace          = "eg"
  stage              = "test"
  name               = "redis-test"
  # Using a large instance vs a micro shaves 5-10 minutes off the run time of the test
  instance_type                    = "cache.t3.small"
  cluster_size                     = 1
  family                           = "redis6.x"
  engine_version                   = "6.x"
  at_rest_encryption_enabled       = false
  transit_encryption_enabled       = true
  zone_id                          = "Z09617592GHZFSYPSTCWV"
  cloudwatch_metric_alarms_enabled = false
}

