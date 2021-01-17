# Network Load Balancer Deployment Example

_This example has been created [by Miha Markočič](https://www.ipspace.net/Team:Miha_Markocic)_

This example deploys AWS network infrastructure (VPC and public subnet), three web servers, and a network load balancer:

## Network infrastructure:

1. Create a new VPC *(10.0.0.0/16)*
2. Create one public *(10.0.1.0/24)* subnet
3. Create internet gateway and associate it with VPC
4. Create a new route table and add a route towards internet gateway for public subnet traffic
5. Create webserver SG *(HTTP, HTTPS and SSH from anywhere; HTTP, HTTPS to anywhere)*

## EC2 instance deployment:

1. Obtain AWS AMI ID for the desired os *(Ubuntu Server 20.04 LTS from Canonical)*
2. Deploy 3 webserver instances in a created public subnet
3. Update apt-get on each instance using *"remote-exec"* Terraform provisioner
4. Run Ansible playbook<sup>1</sup> using *"local-exec"* Terraform provisioner to:

    - Install Apache service on all 3 Ubuntu servers
    - Enable *Includes* and *cgi* Apache2 modules
    - Copy [*.htaccess*](https://github.com/MihaMarkocic/cloudservices/blob/master/AWS/load_balancer/webserver/.htaccess) file with to *var/www/html/*
    - Enable *XBitHack* in *apache2.conf* configuration file
    - Add *Includes* to the *var/www/* directory in *apache2.conf*
    - Replace [*index.html*](https://github.com/MihaMarkocic/cloudservices/blob/master/AWS/load_balancer/webserver/index.html) file. Replaced html homepage is set to show webserver's *ifconfig*.
    - Restart Apache service

---

<sup>1</sup> Ansible Playbook is run only once with the remote provisioner as there are all 3 webservers in the Ansible inventory. Ansible inventory uses **aws_ec2** plugin.

## Network Load Balancer

1. Deploy network load balancer with an elastic IP in a public subnet with 3 webserver instances
2. Create 2 load balancer listeners listening to the incoming traffic:
    - Forwarding the incoming *HTTP* requests on port 80
    - Forwarding the incoming *HTTPS* requests on port 443
3. Create 2 target groups *(HTTP and HTTPS)* to distribute the load between the targets
4. Create target group attachments to attach individual instance/node to the desired target group<sup>2</sup>. In this example, all 3 instances *(webserver1, webserver2, webserver3)* are associated with *http* and *https* target group.

---

<sup>2</sup> All targets in the same target group have to run the same service.

