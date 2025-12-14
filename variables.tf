variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "EC2 Key Pair Name"
  type        = string
}

variable "vpc_id" {
  description = "Existing VPC ID"
  type        = string
}

variable "subnet_id" {
  description = "Subnet in which EC2 will be launched"
  type        = string
}

variable "project_name" {
  description = "Name prefix"
  type        = string
  default     = "strapi"
}
