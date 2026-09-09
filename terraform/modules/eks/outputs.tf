output "cluster_id" {
  description = "The EKS cluster ID."
  value       = aws_eks_cluster.this.id
}

output "cluster_name" {
  description = "The EKS cluster name."
  value       = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  description = "The EKS cluster API endpoint."
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_certificate_authority_data" {
  description = "Base64-encoded certificate authority data for the EKS cluster."
  value       = aws_eks_cluster.this.certificate_authority[0].data
}

output "oidc_provider_arn" {
  description = "OIDC provider ARN used for IRSA and IAM federation."
  value       = aws_iam_openid_connect_provider.eks.arn
}

output "node_group_name" {
  description = "The managed node group name."
  value       = aws_eks_node_group.this.node_group_name
}
