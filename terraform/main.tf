module "networking" {
  source = "./modules/networking"

  project_name = var.project_name
  environment  = var.environment

  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr

  availability_zone = var.availability_zone
}

module "security" {
  source = "./modules/security"

  project_name = var.project_name
  environment  = var.environment

  vpc_id = module.networking.vpc_id
}

module "compute" {
  source = "./modules/compute"

  project_name = var.project_name
  environment  = var.environment

  private_subnet_id = module.networking.private_subnet_id

  security_group_id = module.security.k8s_instance_sg_id

  instance_type = var.instance_type
}
