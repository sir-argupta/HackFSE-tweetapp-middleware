terraform {
  required_providers {
    mongodbatlas = {
      source = "mongodb/mongodbatlas"
      version = "0.9.0"
    }
  }
}

provider "mongodbatlas" {
  public_key = "flijford"
  private_key  = "12bfdf7d-d624-41c2-a13a-c548bf057b6f"
}

module "mongodb" {
  source                = "toluna-terraform/terraform-aws-mongodb"
  version               = "~>0.0.1" // Change to the required version.
  environment           = "test-environment"
  app_name              = "test-app"
  aws_profile           = "my-aws-profile"
  env_type              = "non-prod"
  atlasprojectid        = "6328ea4f35028b6ded5bb7a2"
  atlas_region          = "US_EAST_1"
  atlas_num_of_replicas = 3
  backup_on_destroy     = true
  restore_on_create     = true
  allowed_envs          = "mv_env"
  db_name               = "test-db"
  init_db_environment   = "src-db"
  init_db_aws_profile   = "src-aws-profile"
  ip_whitelist          = ["0.0.0.0","127.0.0.2","127.0.0.3"]
  atlas_num_of_shards         = 1
  mongo_db_major_version      = "4.2"
  disk_size_gb                = 10
  provider_disk_iops          = 1000
  provider_volume_type        = "STANDARD"
  provider_instance_size_name = "M10"
  aws_vpce = ""
}