resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name                = "cpu-alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []

  dimensions = {
    AutoScalingGroupName = aws_elastic_beanstalk_environment.flask_app_env.autoscaling_groups[0]
  }
}