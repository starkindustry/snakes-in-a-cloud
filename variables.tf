variable "region" {
  type        = string
  description = "The region the environment will be launched within"
}

variable "subnet_az" {
  type        = list(string)
  description = "AZs for the public subnets"
}

variable "email" {
  type        = string
  description = "Email for sending CloudWatch alarm info to"
}
