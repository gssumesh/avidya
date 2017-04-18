### avidya: My effort while trying to unlearn and learn new ways of working. 
 
## Crux of Project:
   1. Try to understand and implement immutable infrastructure
   2. Use Terraform for Infrastructure Provisioning. Dockerize it.
   3. Use Ansible for Configuration management. Dockerize it.
   4. Use Docker for application containarisation and kubernetes for deployment. Dockerize it.

## Chapter 1:
   1. Dockerize terraform with Dockerfile. It uses official Terraform docker image as base image but gives us flexibility to add more custom stuff later.
   2. Built Docker image ``` docker build -t gssumesh/avidya .```
   3. Run image to see help option : ``` docker run --rm gssumesh/avidya ```

## Chapter 2:
   1. Created a directory infrastructure_provisioning to store terraform files
   2. `aws_provisioning.tf` file is used to create our first AWS resource with terraform. It accepts 3 variables access_key, secret_key and region
   3. `prod_config.tf` file is our variable file, which list all our config variables and its default.
   4. Updated Dockerfile for our image to accept new Environment variable which is used to pass in AWS credentials through commandline.
   5. Rebuild our image ``` docker build -t gssumesh/avidya .```
   6. Execute terraform plan to view changes 
      ``` docker run --rm -v /PATH_TO_YOUR_REPOSITORY/avidya/infrastructure_provisioning:/infrastructure_provisioning -e TF_VAR_access_key=YOUR_AWS_ACCESS_KEY -e TF_VAR_secret_key=YOUR_AWS_SECRET_KEY gssumesh/avidya plan /infrastructure_provisioning  ```
   7. Above command attaches infrastructure_provisioning folder as volume to docker container. Pass AWS creds and executes terraform plan. This will output possible changes because of this execution. Result will look like below.

```
+ aws_instance.avidya_microservice_prod_ec2
    ami:                         "ami-2757f631"
    associate_public_ip_address: "<computed>"
    availability_zone:           "<computed>"
    ebs_block_device.#:          "<computed>"
    ephemeral_block_device.#:    "<computed>"
    instance_state:              "<computed>"
    instance_type:               "t2.micro"
    ipv6_addresses.#:            "<computed>"
    key_name:                    "<computed>"
    network_interface_id:        "<computed>"
    placement_group:             "<computed>"
    private_dns:                 "<computed>"
    private_ip:                  "<computed>"
    public_dns:                  "<computed>"
    public_ip:                   "<computed>"
    root_block_device.#:         "<computed>"
    security_groups.#:           "<computed>"
    source_dest_check:           "true"
    subnet_id:                   "<computed>"
    tags.%:                      "2"
    tags.Env:                    "prod"
    tags.Name:                   "avidya_microservice"
    tenancy:                     "<computed>"
    vpc_security_group_ids.#:    "<computed>"


Plan: 1 to add, 0 to change, 0 to destroy.

```
  8. Terraform plan shows what changes Terraform will apply to your infrastructure given current state of our infrastructure

## Chapter 3:
  1. Let us apply changes and create infrastructure in AWS.
     ```  docker run --rm -v /PATH_TO_YOUR_REPOSITORY/avidya/infrastructure_provisioning:/infrastructure_provisioning -e TF_VAR_access_key=YOUR_AWS_ACCESS_KEY -e TF_VAR_secret_key=YOUR_AWS_SECRET_KEY gssumesh/avidya apply /infrastructure_provisioning  ```
  2. If we rerun above command again, we will see that terraform wil recreate the instance. You can again run terraform plan to see addition of new ec2 instane.
  3. Why does this happen? This is because terraform relies on state file which is generated while applying terraform plan to find difference in infrastructure. By default, it creates `terraform.tfstate` during "apply" phase and refer to this file during future "plan" or "apply". Hence, we need to persist the state file locally.
  4. Execute  apply command like this :
     ``` docker run --rm -v /PATH_TO_YOUR_REPOSITORY/avidya/infrastructure_provisioning:/infrastructure_provisioning -e TF_VAR_access_key=YOUR_AWS_ACCESS_KEY -e TF_VAR_secret_key=YOUR_AWS_SECRET_KEY gssumesh/avidya apply -state=/infrastructure_provisioning/aws_provisioning.tfstate /infrastructure_provisioning ```
  5. It will create a state file `infrastructure_provisioning/aws_provisioning.tfstate` , which has all information needed by terraform to determine state of our infrastructure.
  6. Execute plan command to see state file in action :
     ``` docker run --rm -v /PATH_TO_YOUR_REPOSITORY/avidya/infrastructure_provisioning:/infrastructure_provisioning -e TF_VAR_access_key=YOUR_AWS_ACCESS_KEY -e TF_VAR_secret_key=YOUR_AWS_SECRET_KEY gssumesh/avidya plan -state=/infrastructure_provisioning/aws_provisioning.tfstate /infrastructure_provisioning  ```
 will output as this :

     ```
 Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.

aws_instance.avidya_microservice_prod_ec2: Refreshing state... (ID: i-XXXXXXX)
No changes. Infrastructure is up-to-date. 

 ```
  7.  Try "show" command to view current state as follows :
      ``` docker run --rm -v /PATH_TO_YOUR_REPOSITORY/avidya/infrastructure_provisioning:/infrastructure_provisioning -e TF_VAR_access_key=YOUR_AWS_ACCESS_KEY -e TF_VAR_secret_key=YOUR_AWS_SECRET_KEY gssumesh/avidya show /infrastructure_provisioning/aws_provisioning.tfstate  ```
  8.  Let us destroy the infrastructure :
     ``` docker run -it --rm -v /PATH_TO_YOUR_REPOSITORY/avidya/infrastructure_provisioning:/infrastructure_provisioning -e TF_VAR_access_key=YOUR_AWS_ACCESS_KEY -e TF_VAR_secret_key=YOUR_AWS_SECRET_KEY gssumesh/avidya destroy -state=/infrastructure_provisioning/aws_provisioning.tfstate /infrastructure_provisioning  ```
  9. Next chapter, we should try remote state in order to version control and store state in remote location.

