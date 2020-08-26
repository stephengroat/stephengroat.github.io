provider datadog {}

resource "datadog_synthetics_test" "test_browser" {
  type = "browser"

  name    = "www.stephengroat.com"
  message = "@stephengroat@gmail.com"
  tags    = []

  status = "live"

  request = {
    method = "HEAD"
    url    = "http://www.stephengroat.com"
  }

  locations = ["aws:eu-central-1", "aws:us-east-2"]

  options = {
    follow_redirects = true
    tick_every       = 43200
  }
}

