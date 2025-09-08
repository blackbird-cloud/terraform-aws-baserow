terraform {
  backend "s3" {
    bucket  = "stackset-terraform-state-91a57e54-c-s3bucketsource-snvrzjiesitc"
    encrypt = true
    key     = "terraform-aws-baserow/terraform.tfstate"
    region  = "eu-central-1"
  }
}
