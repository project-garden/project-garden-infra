module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.26.6"

  cluster_name    = local.cluster_name
  cluster_version = "1.24"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_group_defaults = {
    ami_type = var.ami_type

    instance_types = [var.instance_type]
  }

  eks_managed_node_groups = {
    one = {
      name = "node-group-one"

      min_size     = 1
      max_size     = 2
      desired_size = 1

      vpc_security_group_ids = [
        aws_security_group.node_group_one.id
      ]
    }

    two = {
      name = "node-group-two"

      min_size     = 1
      max_size     = 2
      desired_size = 1

      vpc_security_group_ids = [
        aws_security_group.node_group_two.id
      ]
    }
  }

  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  manage_aws_auth_configmap = true

  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::229475678484:user/husni-development"
      username = "husni-development"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::229475678484:user/idan-development"
      username = "idan-development"
      groups   = ["system:masters"]
    },
  ]

  aws_auth_accounts = [
    "229475678484",
  ]

  tags = {
    Name = local.cluster_name
    Environment = "development"
    Type = "kubernetes-cluster"
    Owner = "infrastructure"
    Created = local.timestamp
  }
}