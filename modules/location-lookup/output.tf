output "location-lookup" {
  description = "Return location name shorthand."
  value = {
    location_short = lower("${var.location_short[var.location]}")
  }
}