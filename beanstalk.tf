resource "aws_elastic_beanstalk_application" "flask_app" {
  name        = "flask-application"
  description = "Flask application running in Elastic Beankstalk"
}

resource "aws_elastic_beanstalk_application_version" "app_version" {
  name        = "flask-application-version-label"
  application = aws_elastic_beanstalk_application.flask_app.name
  description = "Flask application version generated by Terraform"
  bucket      = aws_s3_bucket.app_src_bucket.id
  key         = aws_s3_object.flask_app_bundle.id
}

resource "aws_elastic_beanstalk_environment" "flask_app_env" {
  name                = "flask-application-environment"
  application         = aws_elastic_beanstalk_application.flask_app.name
  solution_stack_name = "64bit Amazon Linux 2 v3.4.1 running Python 3.8"
  cname_prefix        = "snakesinacloud-${terraform.workspace}"
  version_label       = aws_elastic_beanstalk_application_version.app_version.name
  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = aws_default_vpc.default.id
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     = "true"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = join(",", [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id])
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.aws_elasticbeanstalk_ec2_instance_profile.arn
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t2.micro"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = "application"
  }

  setting {
    namespace = "aws:elbv2:listener:default"
    name      = "ListenerEnabled"
    value     = "false"
  }

  setting {
    namespace = "aws:elbv2:listener:443"
    name      = "Protocol"
    value     = "HTTPS"
  }

  setting {
    namespace = "aws:elbv2:listener:443"
    name      = "SSLPolicy"
    value     = "ELBSecurityPolicy-2016-08"
  }

  setting {
    namespace = "aws:elbv2:listener:443"
    name      = "SSLCertificateArns"
    value     = aws_acm_certificate.self_signed_certificate.arn
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "LowerThreshold"
    value     = "20"
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "UpperThreshold"
    value     = "60"
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "UpperThreshold"
    value     = "20"
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "MeasureName"
    value     = "CPUUtilization"
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "Unit"
    value     = "Percent"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = 1
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = 2
  }
}