# Aluminum-Redis Terraform

This is a terraform script that launches a Amazon Elasticache for Redis cluster with cache.t3.small nodes.
 
# Prerequisites

[-Terraform](https://www.terraform.io/downloads.html)

Simply download at the link and follow the installer instructions

[-aws account](https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/)

Follow the link and create an AWS account. You can start with the free trail.

[-aws cli ](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)

After installing the amazon cli tool you must then configure it to your amazon account. Login to your AWS account and go to the IAM pannel. Go to users and create a new user with admin access. Next go to access keys and create an access key. Download the csv file. Type aws configure into your command line. Input your access and secret key from the CSV file and select your default region and select json as your output. 



# Running the program

To run the program input these command into your command line tool


Make a new directory

> mkdir AluminumRedisTerraform

Enter that directory

> cd AluminumRedisTerraform

Clone the github repo

> git clone https://github.com/francorovaretti/tf-aws-elasticache-for-redis.git

Initialize the terraform repository

> terraform init

When prompted with a region refer to your current aws region, found in the top right of the dashboard. This command will then scan for faults before they are commited

> terraform plan

This will commit your changes to AWS. Ensure you're code is correct before this because it may take a while to commit

> terraform apply -var-file=foundry.tfvars

To clean up run 

>terraform destroy
