variable "region" {
  description = "Availability zones for the project"
  default     = "us-east-1"
}
variable "vpc_cidr" {
  description = "CIDR Range for the VPC"
  default     = "10.10.0.0/16"
}
variable "ecs_cluster_name"{
    default = "Production-ECS-Cluster"
}
variable "internet_cidr_block"{
    default = "0.0.0.0/0"
}

variable "ecs_service_name"{
    default = "grafanaApp"
}  
variable "docker_container_port"{
    default = 3000
}
variable "docker_image_url"{
    default = "https://hub.docker.com/r/grafana/grafana"
}
variable "desired_task_number"{
    default = "2"
}
variable "memory"{
    default = 1024
}
variable "version_profile"{
    default = "1.0"
}