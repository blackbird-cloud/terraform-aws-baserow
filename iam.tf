resource "aws_iam_role" "eks" {
  name               = "${var.name}-eks-role"
  assume_role_policy = data.aws_iam_policy_document.eks_assume_role.json
  tags               = var.tags
}

data "aws_iam_policy_document" "eks_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com", "eks-fargate-pods.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "baserow_eks" {
  role       = aws_iam_role.eks.name
  policy_arn = aws_iam_policy.baserow_backend.arn
}

resource "aws_iam_policy" "baserow_backend" {
  name        = "${var.name}-baserow-backend-policy"
  description = "IAM policy for Baserow backend to access AWS resources"
  policy      = data.aws_iam_policy_document.baserow_backend.json
}

data "aws_iam_policy_document" "baserow_backend" {
  statement {
    actions = [
      "kms:DescribeKey",
      "kms:Decrypt",
      "kms:Encrypt",
      "kms:GenerateDataKey*"
    ]
    resources = [
      aws_kms_key.rds.arn,
      aws_kms_key.s3.arn,
      aws_kms_key.valkey.arn
    ]
  }

  statement {
    actions = ["secretsmanager:GetSecretValue", "secretsmanager:DescribeSecret"]
    resources = [
      module.aurora.cluster_master_user_secret[0].secret_arn,
      data.aws_secretsmanager_secret.rds.arn
    ]
  }

  statement {
    actions = ["s3:*"]
    resources = [
      module.s3_bucket.s3_bucket_arn,
      "${module.s3_bucket.s3_bucket_arn}/*"
    ]
  }
}
