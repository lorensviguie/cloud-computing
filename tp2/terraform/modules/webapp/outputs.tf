output "web_app_default_hostname" {
  value = azurerm_web_app.app.default_site_hostname
}
output "web_app_url" {
  value = "https://${azurerm_web_app.app.default_site_hostname}"
}