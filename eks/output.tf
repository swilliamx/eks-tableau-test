output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.dev-cluster.name
}

output "eks_iam_role" {
  description = "IAM role for EKS cluster"
  value       = aws_iam_role.eksclusterrole.arn
}

output "endpoint" {
  value = aws_eks_cluster.dev-cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.dev-cluster.certificate_authority[0].data
}

output "eks_iam_role_nodegroup" {
  description = "IAM role for EKS cluster nodegroup"
  value       = aws_iam_role.nodegroup.arn
}
