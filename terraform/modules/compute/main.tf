resource "aws_instance" "numeraid_k8s_cp" {
  ami           = data.aws_ami.ubuntu.id
  subnet_id     = var.private_subnet_id
  instance_type = var.instance_type

  vpc_security_group_ids = [
    var.security_group_id
  ]

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-k8s-cp"
  })
}

resource "aws_instance" "numeraid_k8s_wn" {
  ami           = data.aws_ami.ubuntu.id
  subnet_id     = var.private_subnet_id
  instance_type = var.instance_type

  vpc_security_group_ids = [
    var.security_group_id
  ]

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-k8s-wn"
  })
}
