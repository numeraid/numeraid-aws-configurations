module "networking" {
  source = "./modules/networking"
  
  project_name = var.project_name
  environment  = var.environment

  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr

  availability_zone = var.availability_zone

  endpoint_security_group_id = module.security.vpc_endpoint_sg_id
}

module "iam" {
  source = "./modules/iam"

  project_name = var.project_name
  environment  = var.environment
}

module "security" {
  source = "./modules/security"

  project_name = var.project_name
  environment  = var.environment

  vpc_id   = module.networking.vpc_id
  vpc_cidr = module.networking.vpc_cidr_block
}

module "compute" {
  source = "./modules/compute"

  project_name = var.project_name
  environment  = var.environment

  private_subnet_id = module.networking.private_subnet_id

  security_group_id = module.security.k8s_instance_sg_id

  instance_profile_name = module.iam.instance_profile_name

  instance_type = var.instance_type
}
