module "networking" {
  source = "./modules/networking"

  project_name = var.project_name
  environment  = var.environment

  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs

  availability_zones = var.availability_zones
}

module "ingress" {
  source = "./modules/ingress"

  project_name = var.project_name
  environment  = var.environment

  vpc_id                = module.networking.vpc_id
  public_subnet_ids     = module.networking.public_subnet_ids
  certificate_arn       = var.alb_certificate_arn
  allowed_ingress_cidrs = var.public_ingress_cidrs
}

module "eks" {
  count  = var.enable_eks ? 1 : 0
  source = "./modules/eks"

  project_name = var.project_name
  environment  = var.environment

  vpc_id                   = module.networking.vpc_id
  private_subnet_ids       = module.networking.private_subnet_ids
  cluster_api_access_cidrs = var.admin_public_cidrs
  cluster_log_types        = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  node_instance_type       = var.instance_type
  node_desired_size        = 2
  node_min_size            = 1
  node_max_size            = 3
}
