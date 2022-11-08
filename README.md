# Snakes in a Cloud!

## Summary

This repository provides an cloud-hosted environment for a simple Flask web application within AWS. The infrastructure
is managed using Terraform and deployed using GitHub Actions. This documentation will guide users through the
architecture of the environment as well as the steps necessary to configure and deploy this environment for themselves.

## The App
The application being deployed is an example 'Hello, World!' Flask application found
[here](https://pythonspot.com/flask-web-app-with-python/). The source code is located within the `/flask_app` directory.
The source code is provided purely for example purposes. At the root of the repository is a `flask_app_v1.zip` file that
will be used to deploy the application into the AWS environment.

## Some Minor Setup
This repository was initialized and deployed into a personal AWS account using root user credentials. While not advisable
in a production scenario, for the purpose of this application, it makes access to services straightforward.

### Deployment Credentials
To deploy into an AWS account, this project requires a set of AWS credentials be made available within the GitHub
secrets configuration. In this example, I used my own personal AWS account and generated a set using the root user and
created two secrets inside the GitHub repository. Terraform will use these in order to execute deployments against the
infrastructure.

```
AWS_ACCESS_KEY_ID=XXXXX
AWS_SECRET_ACCESS_KEY=XXXXX
```

This was a simple solution for this instance. In a real production setting, I would recommend using a set of one or more
managed service users with limited permissions to deploy to the infrastructure, reducing the blast radius in case of a
breach.

### Terraform State and Workspaces
This repository tracks Terraform changes using remote state via an S3 bucket. Before Terraform can launch deployments
automatically into the AWS environment, a bucket to track the state needs to be created. The `main.tf` file has a bucket
defined as well as a region. However, that will need to be changed for each new account that initializes this project
since bucket names are globally unique.

Once a bucket has been created in your account, fill out the bucket and region variables in the `main.tf` to match those
values.

After that, you can run the `bootstrap_terraform.sh` file to quickly set up the state bucket and the workspaces that
govern deployments into each environment (staging and production).

Now when you push to GitHub whether it is for a PR or merging code in the main trunk, Terraform can deploy unique
resources across environments using a single state.

### CloudWatch Alarms
This insfrastucture environment is configured to monitor CPU utilization within the Elastic Beanstalk environment and
send off an email via an AWS SNS topic should it reach 80% or higher (more on that later).

The `production.tfvars` and `staging.tfvars` both have email addresses set to be able to alerts recipients. Update that
email address as you choose in order to tailor your alert notifications.

## Workflows
This app is automatically deployed using a GitHub Actions CI/CD pipeline. There are two main workflows, described below.

### Staging Workflow
The staging workflow runs automatically upon the creation of a pull request to the main branch. The workflow will then
perform several actions:

1. Run a check using the Terraform formatter to ensure the code is structurally standardized
2. Initialize the Terraform environment for executing against the environment
3. Execute a basic Terraform plan on the code against the staging environment
4. Apply the planned code within the staging environment

### Production Workflow
The production workflow automatically executions upon the merge of a pull request to the main branch. The workflow will
then perform the same actions as described above in the staging workflow section, except on the production environment.

## The Results

### Self-Signed Certificates
The setup documentation and the details of the workflows is great and all, but what we all care about is the results!
Once these environments are deployed into AWS, users should be able to navigate to the HTTPS address of the ALB in order
to see the deployed application running.

Further, I've uploaded self-signed certificates to use with the ALB. Route 53 won't route traffic in a zone that hasn't
been verified, but you can run a few commands in your local environment to confirm that the certs are present and
working.

```
dig <ALB_DNS_HOSTNAME>
```
Copy an IP address from the resulting output (there will likely be more than one).

In your `/etc/hosts` file, insert the following line. In this case, I've used the hostname of the staging environment.
```
<COPIED_IP_ADDRESS> snakes-app.snakesinacloud-staging-starkindustry.com
```

Save and exit. Now you should be able to place that hostname into your browser and navigate to the site. You'll get an
SSL warning, of course, but ignoring it will allow you to see the app and dig into the details of the certificate.

### Load Testing and Alarms
If you've configured your email address to subscribe to the SNS topic, you'll likely have received a confirmation
message. Click 'Confirm Subscription' on that email and you should be set up to receive notifications on the health of
the Elastic Beanstalk stack.

Now the fun stuff! I found and tried a library I was not familiar with called [k6](https://k6.io/docs/). It allows you
to write simple JS scripts in order to perform different kinds of load testing against targets of your choice. In order
to test the scaling of the environment as well as the alarms, I configured this tool locally and ran it against the
application.

The app is easy to install on Mac via Homebrew.

```
brew install k6
```

I've provided a `load-testing.js` file which batches calls to a few different valid URLS and then simulates hundreds of
concurrent virtual users accessing those URL for a specific duration. The script is longer running ~20m in order to
effectively build load.

It can be run from the command line:
```
k6 run load-testing.js --insecure-skip-tls-verify
```

Using this method I was able to successfully trigger a scale up of the environment as well as create an alarm.
