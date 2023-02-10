resource "aws_security_group" "node_group_one" {
  name_prefix = "node_group_one"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/8",
    ]
  }

  tags = {
    Name = "node_group_one"
    Environment = "development"
    Owner = "infrastructure"
    Created = local.timestamp
    Type = "secgroup"
  }
}

resource "aws_security_group" "node_group_two" {
  name_prefix = "node_group_two"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "192.168.0.0/16",
    ]
  }

  tags = {
    Name = "node_group_two"
    Environment = "development"
    Owner = "infrastructure"
    Created = local.timestamp
    Type = "secgroup"
  }
}