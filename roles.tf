resource "aws_iam_role" "aws_elasticbeanstalk_ec2_role" {
  name = "aws-elasticbeanstalk-ec2-role-${terraform.workspace}"
  assume_role_policy = jsonencode({
    "Version" : "2008-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "beanstalk_webtier" {
  name       = "beanstalk-ec2-webtier-attachment-${terraform.workspace}"
  roles      = [aws_iam_role.aws_elasticbeanstalk_ec2_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_instance_profile" "aws_elasticbeanstalk_ec2_instance_profile" {
  name = "aws-elasticbeanstalk-ec2-instance-profile-${terraform.workspace}"
  role = aws_iam_role.aws_elasticbeanstalk_ec2_role.name
}
