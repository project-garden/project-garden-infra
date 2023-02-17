
variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

# variable "credentials" {
#   description = "AWS credentials file"
#   type        = string
#   default     = "/Users/husni/.aws/credentials"
# }

# variable "profile" {
#   description = "AWS CLI profile"
#   type        = string
#   default     = "husni-development"
# }

variable "ami_type" {
  description = "AMI type of node/vm"
  type        = string
  default     = "AL2_x86_64"
}

variable "instance_type" {
  description = "Instance type of node/vm"
  type        = string
  default     = "t3.medium"
}