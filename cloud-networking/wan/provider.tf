//https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference
provider "google" {
  credentials = file("sa-key.json")

  project = "module3-454719"
  region  = "us-central1"
  zone    = "us-central1-c"
}