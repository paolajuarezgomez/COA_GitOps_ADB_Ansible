# COA DevOps Training UseCase
This project provides the documentation and the automation code for the Oracle EMEA WLA COA Demo UseCase.

We're going to showcase, by following a realistic usecase, the following:
* a recomended terraform demo template
* abstracting terraform configuration
* best practices around: code, project structure, data structures, optional configuration, functions, modules  and many more
* we'll drive you through a few operations scenarios use-cases that cover both IaC and configuration management

## Demo environment arhitecture diagram

![Arhitecture diagram](./Diagrams/COA-Demo-Diagram.png)

## Demo Usecase scenario

In this example a DevOps engineer will leverage an IaC and Configuration Management automation to: 
* provision the following OCI Infrastructure:
    * Networking:
        * one VCN and 2 subnets(private and public)
        * coresponding security rules
        * Internet and NAT GW
        * Routing rules
    * Compute:
        * one bastion host VM instance exposed on the public subnet
        * A configurable number of WEB Servers exposed to the private subnet
    * LBaaS:
        * A load balancer, exposed to the public subnet, containing:
            *  backend set containing:
                * a configurable number of backend servers 
            * a configurable number of listerners with SSL/no-SSL option
    * ATP-S database
    
* running the following configuration(terraform remote exec provider) on the provisioned VMs:
    * on bastion host:
        * upload the private ssh_key to access the backend webserver VMs
    * on the WEB Server VMs:
        * configure ```iptables``` to open port 80
        * install NGINX,  Apache webserver or Flask (we are choosing Flask) configure them to listen on port ```80```.

On this topology we'll be able to demostrate the operations described bellow.

## Demo automation supported operations

* Infrastructure provisioning
* Configuration management
* Include configuration into the terraform dependency graph(install/uninstall) - (TBA)
* Change management system - ex. open port
* SSH public key rotation (TBA)
* LBaaS Certificate rotation (TBA)
* Cluster Scale Up/Down (TBA)

## Steps
* Clone this repo in OraHub, GitLab or GitHub and create you own repository.
* Rename the file **terraform.tfvars.template** to **terraform.tfvars** and add the values of *tenancy_ocid*, *user_id*, *fingerprint*, *private_key_path* and *region*
* Review and change if you want the values included in **coa_demo.auto.tfvars** ,add at least the values of *compartment_ocid* ,* ssh_public_key_path* and *ssh_private_key_path* 
* run terraform steps:

````
terraform init
terraform plan
terraform apply --auto-aprove
````
* Review the outputs and search for the Load Balancer public Ip and check you can connect to the Flask app

## Terraform project design and best practices
This automation example is meant to also cover a set of terraform coding examples and best practices and provide some standardization of how a terraform project should be structured.
* [Best Practices](Best%20Practices.md)

