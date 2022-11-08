resource "aws_sns_topic" "flask_app_topic" {
  name            = "flask-app-topic"
  delivery_policy = <<EOF
{
    "http": {
        "defaultHealthyRetryPolicy": {
            "minDelayTarget": 20,
            "maxDelayTarget": 20,
            "numRetries": 3,
            "numMaxDelayRetries": 0,
            "numNoDelayRetries": 0,
            "numMinDelayRetries": 0,
            "backoffFunction": "linear"
        },
        "disableSubscriptionOverrides": false,
        "defaultThrottlePolicy": {
            "maxReceivesPerSecond": 1
        }
    }
}
EOF
}

resource "aws_sns_topic_subscription" "flask_email_sub" {
  topic_arn = aws_sns_topic.flask_app_topic.arn
  protocol  = "email"
  endpoint  = var.email
}