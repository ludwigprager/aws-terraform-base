terraform {  
    backend "s3" {
        encrypt        = true
        key            = "poc1/terraform.tfstate"
    }
}
