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

module "bastion" {
  source = "./modules/bastion"

  project_name     = var.project_name
  environment      = var.environment

  vpc_id           = module.networking.vpc_id
  public_subnet_id = module.networking.public_subnet_id

  key_name         = module.compute.key_name
  instance_type    = "t3.micro"
}

module "compute" {
  source = "./modules/compute"

  project_name = var.project_name
  environment  = var.environment

  private_subnet_id = module.networking.private_subnet_id
  security_group_id = module.security.security_group_id

  ami_id        = var.ami_id
  instance_type = var.instance_type
}

resource "aws_security_group_rule" "ssh_from_bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.security.security_group_id
  source_security_group_id = module.bastion.bastion_security_group_id
  description              = "Allow SSH from Bastion SG"
}
