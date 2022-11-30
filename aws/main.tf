locals {
  name_prefix = substr("${var.customer_name}-${var.cluster_name}-certmanager", 0, 32)
  use_oidc = var.cluster_oidc_issuer_url != ""
  use_iam  = var.cluster_oidc_issuer_url == ""
}

data "aws_iam_policy_document" "aws_certmanager" {
  statement {
    effect = "Allow"

    actions = [
      "route53:GetChange"
    ]

    resources = [
      "arn:aws:route53:::change/*"
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "route53:ChangeResourceRecordSets"
    ]

    resources = [for id in var.hosted_zone_ids : "arn:aws:route53:::hostedzone/${id}"]
  }

  statement {
    effect = "Allow"

    actions = [
      "route53:ListHostedZonesByName"
    ]

    resources = [
      "*"
    ]
  }
}

### AUTH BY IRSA

module "irsa_aws_certmanager" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "~> 4.2"

  count                         = local.use_oidc ? 1 : 0
  create_role                   = true
  role_name                     = local.name_prefix
  provider_url                  = var.cluster_oidc_issuer_url
  role_policy_arns              = [aws_iam_policy.aws_certmanager.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${var.service_account_namespace}:${var.service_account_name}"]
  tags                          = var.tags
}

resource "aws_iam_policy" "aws_certmanager" {
  name        = local.name_prefix
  description = "Cert manager policy for EKS cluster ${var.cluster_name}"
  policy      = data.aws_iam_policy_document.aws_certmanager.json
}

### AUTH BY SECRET

resource "aws_iam_user" "aws_certmanager" {
  count = local.use_iam ? 1 : 0
  name  = local.name_prefix
}

resource "aws_iam_access_key" "aws_certmanager" {
  count = local.use_iam ? 1 : 0
  user = aws_iam_user.aws_certmanager[0].name
}

resource "aws_iam_user_policy" "aws_certmanager" {
  count = local.use_iam ? 1 : 0
  name_prefix = local.name_prefix
  user = aws_iam_user.aws_certmanager[0].name

  policy = data.aws_iam_policy_document.aws_certmanager.json
}
