output "baserow_backend_role_arn" {
  value       = aws_iam_role.baserow_backend.arn
  description = "The ARN of the IAM role used by the EKS cluster for Baserow backend."
}
