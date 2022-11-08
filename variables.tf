variable "region" {
  type        = string
  description = "The region the environment will be launched within"
}

variable "subnet_az" {
  type        = list(string)
  description = "AZs for the public subnets"
}
