output "webapp_url" {
  value = module.webapp.web_app_url
}
output "mysql_fqdn_private" {
  value = module.mysql.mysql_fqdn_private
}
output "acr_login_server" {
  value = module.acr.acr_login_server
}