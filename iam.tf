resource "aws_iam_role" "eks" {
  name               = "${var.name}-eks-role"
  assume_role_policy = data.aws_iam_policy_document.eks_assume_role.json
  tags               = var.tags
}

data "aws_iam_policy_document" "eks_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [module.eks.oidc_provider_arn]
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.cluster_oidc_issuer_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:my-baserow:baserow"]
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.cluster_oidc_issuer_url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
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

##############################################
# ALB Controller role
##############################################

resource "aws_iam_role" "eks_alb_controller" {
  name               = "${var.name}-eks-alb-controller-role"
  assume_role_policy = data.aws_iam_policy_document.eks_alb_controller_assume_role.json
  tags               = var.tags
}

data "aws_iam_policy_document" "eks_alb_controller_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [module.eks.oidc_provider_arn]
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.cluster_oidc_issuer_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.cluster_oidc_issuer_url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "eks_alb_controller" {
  role       = aws_iam_role.eks_alb_controller.name
  policy_arn = aws_iam_policy.eks_alb_controller.arn
}

resource "aws_iam_policy" "eks_alb_controller" {
  name        = "${var.name}-eks-alb-controller-policy"
  description = "IAM policy for EKS ALB Controller to access AWS resources"
  policy      = file("./policies/iam-policy.json")
}
