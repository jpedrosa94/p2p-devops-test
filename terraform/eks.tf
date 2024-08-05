locals {
  name   = "ex-${basename(path.cwd)}"
  region = "us-east-1"

  vpc_cidr = "10.1.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.11"

  cluster_name                             = local.name
  cluster_version                          = "1.30"
  enable_cluster_creator_admin_permissions = true
  cluster_endpoint_public_access           = true

  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets

  eks_managed_node_groups = {
    karpenter = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["m5.large"]

      min_size     = 3
      max_size     = 5
      desired_size = 3

      #       taints = {
      #         # This Taint aims to keep just EKS Addons and Karpenter running on this MNG
      #         # The pods that do not tolerate this taint should run on nodes created by Karpenter
      #         addons = {
      #           key    = "CriticalAddonsOnly"
      #           value  = "true"
      #           effect = "NO_SCHEDULE"
      #         }
      #       }
    }
  }
  cluster_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
  }
}

################################################################################
# EKS Blueprints Addons
################################################################################

module "eks_blueprints_addons" {
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "~> 1.16"

  cluster_name      = module.eks.cluster_name
  cluster_endpoint  = module.eks.cluster_endpoint
  cluster_version   = module.eks.cluster_version
  oidc_provider_arn = module.eks.oidc_provider_arn
  #
  #   enable_aws_load_balancer_controller = true
  #   enable_metrics_server               = true
  #   enable_external_dns                 = true
  #   external_dns = {
  #     values = [templatefile("../helm/environments/${terraform.workspace}/cluster-bootstrap/values/external-dns.yaml", {})]
  #   }
  #   enable_argocd = true
  #   argocd = {
  #     name          = "argocd"
  #     chart_version = "7.3.4"
  #     repository    = "https://argoproj.github.io/argo-helm"
  #     namespace     = "argocd"
  #     values        = [templatefile("../helm/environments/${terraform.workspace}/argo-bootstrap/values/argo.yaml", {})]
  #
  #   }
}
