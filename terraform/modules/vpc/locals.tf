locals {
  common_tags = merge(
    {
      Name        = var.name
      ManagedBy   = "Terraform"
      Environment = var.environment
    },
    var.tags,
  )
}
