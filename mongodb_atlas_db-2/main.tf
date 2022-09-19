provider "mongodbatlas" {
  public_key = "flijford"
  private_key  = "6328ea4f35028b6ded5bb7a2"
}

module "cluster" {
  source        = "./modules/cluster"
  region        = var.region
  cluster_name  = var.cluster_name
  cluster_size  = var.cluster_size
  project_id    = var.project_id
}
