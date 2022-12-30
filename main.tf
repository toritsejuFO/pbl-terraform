module "VPC" {
  source                              = "./modules/VPC"
  name                                = var.name
  region                              = var.region
  vpc_cidr                            = var.vpc_cidr
  enable_dns_support                  = var.enable_dns_support
  enable_dns_hostnames                = var.enable_dns_hostnames
  preferred_number_of_public_subnets  = var.preferred_number_of_public_subnets
  preferred_number_of_private_subnets = var.preferred_number_of_private_subnets
  private_subnets_cidrs               = [for i in range(1, 8, 2) : cidrsubnet(var.vpc_cidr, 8, i)]
  public_subnets_cidrs                = [for i in range(2, 5, 2) : cidrsubnet(var.vpc_cidr, 8, i)]
  tags                                = var.tags
}

module "ALB" {
  source             = "./modules/ALB"
  name               = var.name
  vpc_id             = module.VPC.vpc_id
  public_sg          = module.Security.ext_lb_sg
  private_sg         = module.Security.int_lb_sg
  public_subnets     = [module.VPC.public_subnet_1_id, module.VPC.public_subnet_2_id]
  private_subnets    = [module.VPC.private_subnet_1_id, module.VPC.private_subnet_2_id]
  load_balancer_type = "application"
  ip_address_type    = "ipv4"
}

module "Security" {
  source = "./modules/Security"
  vpc_id = module.VPC.vpc_id
  name   = var.name
  tags   = var.tags
}

module "AutoScaling" {
  source           = "./modules/Autoscaling"
  web_ami          = var.webserver_ami
  bastion_ami      = var.bastion_ami
  nginx_ami        = var.nginx_ami
  desired_capacity = 1
  min_size         = 1
  max_size         = 2
  web_sg           = [module.Security.web_sg]
  bastion_sg       = [module.Security.bastion_sg]
  nginx_sg         = [module.Security.nginx_sg]
  wordpress_lb_tg  = module.ALB.wordpress_lb_tg_arn
  nginx_lb_tg      = module.ALB.nginx_lb_tg_arn
  tooling_lb_tg    = module.ALB.tooling_lb_tg_arn
  instance_profile = module.VPC.instance_profile_id
  public_subnets   = [module.VPC.public_subnet_1_id, module.VPC.public_subnet_2_id]
  private_subnets  = [module.VPC.private_subnet_1_id, module.VPC.private_subnet_2_id]
  keypair          = var.keypair
  name             = var.name
  tags             = var.tags
}

module "EFS" {
  source         = "./modules/EFS"
  efs_subnets    = [module.VPC.private_subnet_1_id, module.VPC.private_subnet_2_id]
  efs_sg         = [module.Security.datalayer_sg]
  billingAccount = var.billingAccount
  name           = var.name
  tags           = var.tags
}

# module "RDS" {
#   source          = "./modules/RDS"
#   master_username = var.master_username
#   master_password = var.master_password
#   db_sg           = [module.Security.datalayer_sg]
#   private_subnets = [module.VPC.private_subnet_3_id, module.VPC.private_subnet_4_id]
#   name            = var.name
#   tags            = var.tags
# }

# Optional, not part of core infrastructure
# The Module creates instances for jenkins, sonarqube abd jfrog
module "Compute" {
  source          = "./modules/compute"
  jenkins_ami     = var.webserver_ami
  sonar_ami       = var.webserver_ami
  jfrog_ami       = var.webserver_ami
  compute_subnets = module.VPC.public_subnet_1_id
  compute_sg      = [module.Security.ext_lb_sg]
  keypair         = var.keypair
  name            = var.name
}
