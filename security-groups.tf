resource "aws_security_group" "ecs_security_group" {
  name        = "${var.ecs_cluster_name}-SG"
  description = "Security group for ECS to communicate in and out"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = var.docker_container_port
    protocol    = "TCP"
    to_port     = var.docker_container_port
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    from_port   = 22
    protocol    = "TCP"
    to_port     = 22
    cidr_blocks = [var.internet_cidr_block]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = [var.internet_cidr_block]
  }

  tags = {
    Name = "${var.ecs_cluster_name}-SG"
  }
}

resource "aws_security_group" "ecs_alb_security_group" {
  name        = "${var.ecs_cluster_name}-ALB-SG"
  description = "Security group for ALB to traffic for ECS cluster"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = 443
    protocol    = "TCP"
    to_port     = 443
    cidr_blocks = [var.internet_cidr_block]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = [var.internet_cidr_block]
  }
}