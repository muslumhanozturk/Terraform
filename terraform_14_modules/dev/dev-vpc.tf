module "tf-vpc" {
  source = "../modules"
  environment = "dev"
  }

output "vpc-cidr-block" {
  value = module.tf-vpc.vpc_cidr
}
