resource "aws_route53_zone" "snakes_in_a_cloud_zone" {
  name = "snakesinacloud-${terraform.workspace}-starkindustry.com"
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.snakes_in_a_cloud_zone.zone_id
  name    = "snakes-app.snakesinacloud-starkindustry.com"
  type    = "CNAME"
  ttl     = 300
  records = [data.aws_alb.beanstalk_alb.dns_name]
}
