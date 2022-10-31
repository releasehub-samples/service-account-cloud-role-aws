data "aws_iam_policy_document" "service_account_role_inline_policy" {
  # Provide your custom role policy here
  statement {
    actions   = ["ec2:DescribeAccountAttributes"]
    resources = ["*"]
  }
}

locals {
  oidc_provider     = trimprefix(data.aws_eks_cluster.releasehub.identity[0].oidc[0].issuer, "https://")
  oidc_provider_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.oidc_provider}"
}

resource "aws_iam_role" "service_account_role" {
  name = var.iam_role_name

  assume_role_policy = data.aws_iam_policy_document.service_account_role_assume_role_policy.json

  inline_policy {
    name   = "service_account_role_policy"
    policy = data.aws_iam_policy_document.service_account_role_inline_policy.json
  }
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "service_account_role_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [local.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_provider}:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "${local.oidc_provider}:sub"
      values   = ["system:serviceaccount:*:${var.releasehub_service_account_name}"]
    }
  }
}

data "aws_eks_cluster" "releasehub" {
  name = var.releasehub_cluster_context
}
