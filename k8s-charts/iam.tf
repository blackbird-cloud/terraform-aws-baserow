##############################################
# Baserow backend role
##############################################

resource "aws_iam_role" "baserow_backend" {
  name               = "${var.name}-eks-role"
  assume_role_policy = data.aws_iam_policy_document.baserow_backend_assume_role.json
  tags               = var.tags
}

data "aws_iam_policy_document" "baserow_backend_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(var.cluster_oidc_issuer_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:my-baserow:baserow"]
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(var.cluster_oidc_issuer_url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "baserow_backend" {
  role       = aws_iam_role.baserow_backend.name
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
      var.kms_rds_arn,
      var.kms_s3_arn,
      var.kms_valkey_arn
    ]
  }

  statement {
    actions = ["secretsmanager:GetSecretValue", "secretsmanager:DescribeSecret"]
    resources = [
      var.db_password_arn
    ]
  }

  statement {
    actions = ["s3:*"]
    resources = [
      var.s3_bucket_arn,
      "${var.s3_bucket_arn}/*"
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
      identifiers = [var.oidc_provider_arn]
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(var.cluster_oidc_issuer_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(var.cluster_oidc_issuer_url, "https://", "")}:aud"
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
  policy      = file("./policies/alb-controller-policy.json")
}
