provider "datadog" {}

variable "subdomains" {
  description = "Subdomains to check"
  type        = set(string)
  default = [
    "", "www"
  ]
}

data "datadog_synthetics_locations" "locations" {}

resource "datadog_synthetics_test" "router" {
  type    = "api"
  subtype = "icmp"

  name    = "router.whipple.groat.us"
  message = "@stephengroat@gmail.com"
  tags    = ["tld:groat.us"]

  status = "live"

  request_definition {
    should_track_hops = true
    host              = "router.whipple.groat.us"
    number_of_packets = 4
  }

  assertion {
    type     = "packetLossPercentage"
    operator = "is"
    target   = "0"
  }

  locations = [for k, v in data.datadog_synthetics.locations: v if length(regexall("aws:us-west-*", v)) > 0]

  options_list {
    tick_every = 60
  }
}

resource "datadog_synthetics_test" "test_browser" {
  for_each = var.subdomains

  type    = "api"
  subtype = "http"

  name    = "${each.value}%{if each.value != ""}.%{endif}stephengroat.com"
  message = "@stephengroat@gmail.com"
  tags    = ["tld:stephengroat.com"]

  status = "live"

  request_definition {
    method = "GET"
    url    = "http://${each.value}%{if each.value != ""}.%{endif}stephengroat.com"
  }

  assertion {
    type     = "statusCode"
    operator = "is"
    target   = "200"
  }

  locations = ["aws:eu-central-1", "aws:us-east-2"]

  options_list {
    tick_every = 43200

    follow_redirects = true
  }
}
