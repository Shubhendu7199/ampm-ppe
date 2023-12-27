resource "random_password" "password" {
  length           = 16
  special          = true
  min_numeric      = 2
  min_special      = 1
  override_special = "'_%@"
}

resource "random_string" "random" {
  length           = 8
  special          = false
  override_special = "/@£$"
}
