terraform {
  backend "s3" {
    bucket = "starkindustry-snakesinacloud-tfstate"
    key    = "snakesinacloud.tfstate"
    region = "us-west-1"
  }
}

provider "aws" {
  region = var.region
}
