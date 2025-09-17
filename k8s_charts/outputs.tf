output "baserow_backend_role_arn" {
  value       = aws_iam_role.baserow_backend.arn
  description = "The ARN of the IAM role used by the EKS cluster for Baserow backend."
}

output "cluster_autoscaler_iam_role_arn" {
  value       = aws_iam_role.cluster_autoscaler.arn
  description = "IAM role ARN for Kubernetes Cluster Autoscaler (use with IRSA in Helm deployment)"
}

output "cluster_autoscaler_helm_release_name" {
  value       = helm_release.cluster_autoscaler.name
  description = "Helm release name for the cluster autoscaler."
}
