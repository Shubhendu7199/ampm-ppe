terraform {
  backend "remote" {
    organization = "Shubhendu"

    workspaces {
      prefix = "cartier-"
    }
  }
}
