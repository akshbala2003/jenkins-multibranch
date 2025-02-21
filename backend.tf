terraform {
  backend "s3" {
    bucket         = "tf-state-aks"
    key            = "infrastructure/${env.BRANCH_NAME}/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-state-locks-aks"
    encrypt        = true
  }
} 