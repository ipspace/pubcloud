# Web Application Firewall & Application Load Balancer Example

_This example has been created [by Miha Markočič](https://www.ipspace.net/Team:Miha_Markocic)_

This example demonstrates how to set up and deploy a Web Application Firewall (WAF) together with Application Load Balancer (ALB) in an AWS cloud deployment. 

WAF lets you monitor the HTTP and HTTPS requests forwarded to the ALB and enables you to control the access to your content based on conditions that you specify. ALB serves as a single contact point and automatically distributes the incoming application traffic among multiple targets such as EC2 instances in one or more availability zones. This way, the availability of your service/application is increased. 

## Details

The infrastructure consists of one VPC with 3 subnets (2 public and 1 private). Public subnets are associated with custom route table and a route to the external network through a custom internet gateway. Both public subnets have one webserver, while private subnet has a private instance (such as a database). Jump host is deployed in one of the public subnets and serves the purpose to provide the SSH connection to other instances. The accessibility of each instance is limited with custom security groups. The HTTP traffic incoming to the webservers is automatically distributed by Application Load Balancer and monitored/controlled by the WAF. 

[*main.tf*](main.tf) file is the main Terraform file used to deploy this demo. This is where the region of deployment, provider and modules are defined. Network infrastructure part of this deployment, including subnet route table internet gateway and security groups creation, is defined in the *Network module*. Deployment of EC2 instances (webservers, private instances and bastion host) is defined in *Compute module*. Application load balancer with defined target groups and listeners for HTTP traffic is defined in *Balancer module* and the Web application firewall in *WAF module*. Apart from modules, short initialization files for webservers and bastion host are available in a separate *init_files* folder.

## Network Module

The [*Network*](modules/network) module:

1. Creates a new VPC *(172.19.0.0/16)*
2. Creates two public *(172.19.1.0/24 & 172.19.2.0/24)* and one private *(172.19.3.0/24)* subnet
3. Creates an internet gateway and associates it with VPC
4. Creates a new route table, and adds a route to an external network through the internet gateway. It associates both public subnets with a custom route table.
5. Creates security groups for different instance types: 

    - Webserver security group (HTTP and HTTPS allowed from anywhere, SSH allowed from bastion SG; all outbound traffic allowed)
    - Bastion security group (SSH allowed from anywhere<sup>1</sup>; all outbound traffic allowed)
    - Database/private security group (SSH allowed from bastion SG; HTTP and MySQL allowed from webserver SG and private SG; all outbound traffic allowed)
    - Application Load Balancer security group (HTTP and HTTPS incoming traffic allowed; all outgoing traffic allowed)

---

<sup>1</sup> SSH should be allowed only from a particular IP Address (your public IP) or IP Address range. Allowing SSH from *all/anywhere* is acceptable only in a demo lab.

## Compute Module

The [*Compute*](modules/compute) module:

1. Obtains AWS AMI ID for the desired OS *(Ubuntu Server 20.04 LTS from Canonical)* in the selected region

2. Deploys bastion host instance in a public subnet and:

    - defines connection parameters (ssh key, IP address and user) for provisioner
    - uses *remote-exec* Terraform provisioner to download [*bastion initialization*](init_files/bastion_init.sh) shell script from this Github repository and run it to configure firewall rules 

2. Deploys webserver instances in every public subnet and:

    - defines connection parameters (ssh key, IP address, user and bastion host) through bastion host for the provisioner
    - uses *remote-exec* Terraform provisioner to download [*webserver initialization*](init_files/webserver_init.sh) script from this Github repository.
    - Run the provisioner script to install apache2 service and configure firewall rules. The script also replaces index.html and configures Apache modules to enable SSI on the servers.

3. Deploys database instance in a private subnet

## Balancer Module

The [*Balancer*](modules/balancer) module:

1. Deploys an Elastic Load Balancer as an external application load balancer, with defined security group and range of subnets.
2. Sets up an HTTP *target group* required to route the specific traffic (in this case HTTP on port 80) to the registered targets.
3. Attaches both webservers to the defined HTTP target group.
4. Creates a *listener* that checks the requests from the clients using protocol and port configured. Listener forwards HTTP traffic coming to port 80 to the defined HTTP *target group*.

## WAF Module

The [*WAF*](/modules/waf) module:

1. Defines regular expression patterns that you want a web application firewall to search for (example: *admin*, *login* and *registration*)
2. Defines a web application firewall access control list with the default action to allow requests that are not captured by the rules.
3. Adds a special rule, to block all the requests that have a specific predefined *regular expression* included in the URL.
4. Associates the web application firewall access control list with the application load balancer.

## Deployment

This section provides a short description of the steps you need to perform in order to deploy and test the infrastructure. 

* Move to the cloned git repo where the *main.tf* file is
* Initialize Terraform with `terraform init` command
* Deploy the infrastructure with `terraform plan` and `terraform apply` commands. 

After the successful deployment, the outputs of instance private/public IP addresses are printed.

## Testing

1. Testing the ALB: visit the URL of the application load balancer, which you can find among the Terraform outputs. By revisiting the site multiple times, you will notice the requests are distributed among both webservers (webserver name is printed on the site, as well as *ifconfig* info).
2. Testing the WAF: By default, the requests made to the ALB are allowed. However specific expression patterns in the URL are set to be blocked. Those expressions are *login*, *admin* and *registration*. By including any of those expressions after the URL of the ALB (*UrlOfTheALB.elb.amazonaws.com/login*), the WAF should block the request and *403 Forbidden* should appear on the screen.
