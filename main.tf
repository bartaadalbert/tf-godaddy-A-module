data "http" "ip" {
  count = var.public_ip == "" ? 1 : 0
  url   = "https://api.ipify.org/"
}

locals {
  ip_address = var.public_ip != "" ? var.public_ip : data.http.ip[0].response_body
}

resource "null_resource" "ping_check" {
  provisioner "local-exec" {
    command = "ping -c 1 ${local.ip_address} > /dev/null 2>&1 && echo true > ${path.module}/ping_result.txt || echo false > ${path.module}/ping_result.txt"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "rm -f ${path.module}/ping_result.txt"
  }

  triggers = {
    ip_address = local.ip_address
  }
}

data "local_file" "ping_result" {
  depends_on = [null_resource.ping_check]
  filename   = "${path.module}/ping_result.txt"
}

resource "null_resource" "godaddy_dns_record" {
  count = length(var.subdomain_list)

  triggers = {
    subdomain  = var.subdomain_list[count.index]
    ip_address = local.ip_address
    domain     = var.domain
    access_key = var.gdd_access_key
    secret_key = var.gdd_secret_key
  }

  provisioner "local-exec" {
    command = <<EOT
      curl -X PUT \
      -H "Content-Type: application/json" \
      -H "Authorization: sso-key ${self.triggers.access_key}:${self.triggers.secret_key}" \
      -H "Accept: application/json" \
      "https://api.godaddy.com/v1/domains/${self.triggers.domain}/records/A/${self.triggers.subdomain}" \
      -d "[{\"data\": \"${self.triggers.ip_address}\", \"ttl\":600}]"
    EOT
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<EOT
      curl -X DELETE \
      -H "Content-Type: application/json" \
      -H "Authorization: sso-key ${self.triggers.access_key}:${self.triggers.secret_key}" \
      -H "Accept: application/json" \
      "https://api.godaddy.com/v1/domains/${self.triggers.domain}/records/A/${self.triggers.subdomain}"
    EOT
  }
}
