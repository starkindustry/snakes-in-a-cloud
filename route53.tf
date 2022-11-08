resource "aws_route53_zone" "snakes_in_a_cloud_zone" {
  name = "snakesinacloud-starkindustry.com"
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.snakes_in_a_cloud_zone.zone_id
  name    = "snakes-app.snakesinacloud-starkindustry.com"
  type    = "A"
  ttl     = 300
  records = [aws_elastic_beanstalk_environment.flask_app_env.load_balancers[0]]
}
