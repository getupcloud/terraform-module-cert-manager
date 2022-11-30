locals {
  name_prefix = substr("${var.customer_name}-${var.cluster_name}-certmanager", 0, 32)
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

resource "aws_iam_policy" "aws_certmanager" {
  count = length(var.hosted_zone_ids) > 0 ? 1 : 0
  name        = local.name_prefix
  description = "Cert manager policy for EKS cluster ${var.cluster_name}"
  policy      = data.aws_iam_policy_document.aws_certmanager.json
}


module "irsa_aws_certmanager" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "~> 4.2"

  create_role                   = true
  role_name                     = local.name_prefix
  provider_url                  = var.cluster_oidc_issuer_url
  role_policy_arns              = length(var.hosted_zone_ids) > 0 ? [aws_iam_policy.aws_certmanager[0].arn] : null
  oidc_fully_qualified_subjects = ["system:serviceaccount:${var.service_account_namespace}:${var.service_account_name}"]
  tags                          = var.tags
}
