provider datadog {}

variable "subdomains" {
  description = "Subdomains to check"
  default     = [
    "", "www"
  ]
}

resource "datadog_synthetics_test" "test_browser" {
  for_each = var.subdomains
  
  type    = "api"
  subtype = "http"

  name    = "${each.value}.stephengroat.com"
  message = "@stephengroat@gmail.com"
  tags    = ["tld:stephengroat.com"]

  status = "live"

  request = {
    method = "HEAD"
    url    = "http://${each.value}.stephengroat.com"
  }

  assertion {
    type     = "statusCode"
    operator = "is"
    target   = "200"
  }

  locations = ["aws:eu-central-1", "aws:us-east-2"]

  options = {
    follow_redirects = true
    tick_every       = 43200
  }
}

