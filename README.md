Chef Stack Cookbook
=============
This project sets the foundation for testing modules required to deploy a sample <a href='https://github.com/rb1whitney/cloud-boot-app'> microservice using HA Proxy load balancers, tomcat application server, and a mysql backend using a Centos 7.1 image.

Attributes
----------
See default attributes in site-cookbooks

Terraform
---------
If you want to use Terraform, please install it and AWS CLI client following with:
http://docs.aws.amazon.com/cli/latest/userguide/installing.html#install-with-pip
https://www.terraform.io/intro/getting-started/install.html

Once done, you can use "aws configure" command to setup your local provider and credentials. Terraform will use them. I recommend setting up a personalized IAM account that has adminstrator privileges in EC2 only.

After setting up Terraform with AWS, you will want a remote config to keep your state rather than your local computer. Remote State Storage is highly suggested over maintaining control state files in version control. I created in S3 US-EAST-1 the following storage bucket: tf-remote-state-storage and then with terraform ran: terraform remote config -backend=s3 -backend-config="bucket=tf-remote-state-storage" -backend-config="key=terraform.tfstate" -backend-config="region=us-east-1" -backend-config="encrypt=true". You can also use Consul as well.

I also highly recommend reading the Terraform guide from Gruntwork: https://blog.gruntwork.io/a-comprehensive-guide-to-terraform-b3d32832baca#.kn7l5sj29

I also wrote a script that will use terraform output for auto scaling group to get current ip addresses on spun up instances:
sh find_auto_scaling_group_instances.sh <<name of auto scaling group>>

The organized terraform stack files with their environments files. To save configuration, I kept the module and main terraform implementation files the same and utilized tfvars to control location specific settings. You have to clear out the .terraform cache folder everytime but with the state files being in S3 I had no issues with this implementation. I created a script to help run this with:
terraform_wrapper.sh <<env>> <<app_type>> <action

Script will clear cache, set terraform state in C3, get all modules, and then invoke action (apply, destroy, plan)

License and Authors
-------------------
Author: Richard Whitney