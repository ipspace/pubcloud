# IP Multicast with AWS Transit Gateway

_This example has been created [by Miha Markočič](https://www.ipspace.net/Team:Miha_Markocic)_

Multicast is a communication protocol used to deliver a single stream of data to multiple receiving instances simultaneously. This means a source host can send a single packet to multiple receiving hosts at the same time. In AWS, transit gateway supports multicast traffic between subnets of VPCs attached to it and serves as a multicast router.

**Read This First**

* Before deploying multicast routing make sure your region of choice supports multicast over transit gateway.
* Multicast cannot be enabled on existing transit gateways. You must deploy a new transit gateway must be deployed.
* There is no support yet for managing transit gateway multicast with Terraform or Ansible. Multicast settings in this example are configured with AWS CLI.

## Details

This demo consists of two VPCs created in the same region, each having one public subnet.The subnet in *VPC A* has only one instance as it is set to be the source of multicast. On the receiver side, subnet in VPC B contains two EC2 instances receiving the IP multicast traffic (enough to test that the traffic is delivered to multiple destinations). Multicast source and receiving instances can also be within the same VPC and/or subnet. Multicast communication is tested with *iPerf* command. 

To be able to login to the instance over SSH, install apache webserver and send multicast UDP packets, a custom security group is created. Further, to access the instance from the internet a simple custom route table and internet gateway is provided, while the multicast is done through a custom transit gateway, as mentioned.

[*main.tf*](https://github.com/MihaMarkocic/cloudservices/blob/master/AWS/ip_multicast/main.tf) is the main Terraform file that defines AWS region, Terraform provider, outputs and modules used to create multicast communication with transit gateway. 

Network infrastructure (creation of VPCs, subnets, route tables, internet gateways and routes) is created in the Network module which is used twice (once per VPC). Compute module which creates an instance and installs appropriate software through remote provisioner was used three times to create one instance in VPC A, and two instances in VPC B. 

As Terraform does not have support for configuring IP multicast on a transit gateway, a part of transit gateway setup was moved to the AWS CLI. After the transit gateway is created with AWS CLI, the Transit module gets the ID of transit gateway created with AWS CLI, and attaches VPCs with their subnets to that transit gateway. The outputs of this module contain infrastructure IDs which are crucial for the creation of transit gateway multicast domains and associations later in the AWS CLI. 

Steps to deploy this infrastructure with AWS CLI and Terraform combined are explained below under *"Deployment steps"* section.

## Network Module

The [Network](modules/network) module:

1. Create a VPC in the configured AS region:
    - VPC A *(10.0.0.0/16)*
    - VPC B *(10.10.0.0/16)*
2. Creates one public subnet in each VPC.
3. Creates an Internet gateway and a route table
4. Associates the route table with the VPC subnet.
5. Adds a default route to the route table to give EC2 instances outgoing Internet access through the Internet gateway.
4. Creates a custom security group in each VPC, allowing SSH and UDP inbound traffic and any outbound traffic: *(SSH\*  on port 22 allowed from anywhere, UDP on port 5001 allowed from anywhere; all outbound traffic allowed)*.

## Transit Module

The [Transit](modules/transit) module:

1. Gets the ID of the transit gateway created with AWS CLI using the following AWS filters:

	- The default AWS TGW private AS number
	- The state of the transit gateway (*available* or *pending*) 
	- The name tag of the transit gateway *(should match the tag name used in AWS CLI)*

2. Attaches VPC A with its subnet to the transit gateway and its default route table.
3. Attaches VPC B with its subnet to the transit gateway and its default route table.

## Compute Module

The [Compute](modules/compute) module:

1. Obtains AWS AMI ID for the desired OS *(Ubuntu Server 20.04 LTS from Canonical)* in a defined region
2. Deploy one server instance in the selected VPC/subnet
3. Associates the server instance with the custom security group
4. Installs Apache web server using *remote-exec* provisioner install apache2 service
     
**Important**

* Only **AWS Nitro** instances can be used as a multicast source
* When using non-Nitro instance as a multicast receiver disable the IP source/destination check on VM NIC.

## Deployment Steps 

This section provides a detailed description of the steps needed to create described "multicast over transit gateway" infrastructure. Nevertheless, it is assumed that the individual has the basic setup/environment configured (Terraform and AWS CLI), a basic understanding of the tools, how to use them and an active subscription/access to the AWS services.

1. From the terminal set the AWS CLI profile and make sure that the default region matches your wishes and the settings in the Terraform files (in this demo the *"eu-west-2"* region is used). You can set the default region in AWS CLI with command

    ```
    aws configure
    ```

    If you have set your profile and want to change just the region you can set it with

    ```
    aws configure set default.region *region*
    ```

2. Use AWS CLI create the [transit gateway](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/create-transit-gateway.html). Enable auto-accepting of shared attachments, default route table association and propagation, DNS support and most importantly **Multicast support** and set the name tag to "Multicast-TG" with

    ```
    aws ec2 create-transit-gateway \
    --description "transit gateway with multicast enabled" \
    --options AutoAcceptSharedAttachments=enable,DefaultRouteTableAssociation=enable,DefaultRouteTablePropagation=enable,DnsSupport=enable,MulticastSupport=enable \
    --tag-specifications 'ResourceType=transit-gateway,Tags=[{Key=Name,Value=Multicast-TG}]'
    ```

    To get the information about deployed transit gateways and their status use
    
    ```
    aws ec2 describe-transit-gateways
    ```

3. Move to the cloned git repo where the *main.tf* file is and initialize Terraform with `terraform init` command.
4. Deploy the infrastructure with `terraform plan` and `terraform apply` commands. It is crucial to run the Terraform deployment *after* you created the multicast-enabled transit gateway. The outputs of AWS infrastructure (transit-gateway ID, subnet IDs, instance NIC IDs, etc.) needed for further configuration will be displayed after a successful deployment.
4. After the Terraform successfully deploys the infrastructure and provision the instances move to the AWS CLI console and create a transit gateway[multicast domain](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/create-transit-gateway-multicast-domain.html). Use the following command to create it, where the transit gateway ID should be replaced with the one you created in a previous step.

    ```
    aws ec2 create-transit-gateway-multicast-domain \
    --transit-gateway-id *tg-12345*
    ```

    Before you proceed with the next step make sure that the multicast domain is up and running:
    
    ```
    aws ec2 describe-transit-gateway-multicast-domains
    ```

    Make sure to save the multicast domain ID, as it will be needed in the following steps!

5. After the transit gateway multicast domain is up and running, [associate the VPC/subnet attachments](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/associate-transit-gateway-multicast-domain.html) (created with Terraform) with the multicast domain. For this step a *multicast domain ID*, *transit gateway VPC attachment ID* and *subnet ID* will be needed

    ```
    aws ec2 associate-transit-gateway-multicast-domain \
    --transit-gateway-multicast-domain-id tgw-mcast-domain-12345 \
    --transit-gateway-attachment-id tgw-attach-12345 \
    --subnet-id subnet-12345
    ```

    Repeat this step for all the subnets you wish to associate with the multicast domain!

6. The only thing missing after the association is the registration of multicast group [members](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/register-transit-gateway-multicast-group-members.html) and [sources](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/register-transit-gateway-multicast-group-sources.html).

    To register the members (receivers) the *network interface card IDs* of instances as well *multicast domain ID* will be needed. Further, the IP of the multicast group should be set.  
		
    ```
    aws ec2 register-transit-gateway-multicast-group-members \
    --transit-gateway-multicast-domain-id tgw-mcast-domain-12345 \
    --group-ip-address 239.0.0.1 \
    --network-interface-ids eni-1234 eni-12345
    ```
    
    The same step with a slightly different command but same multicast IP address must be repeated for the sources
    
    ```
    aws ec2 register-transit-gateway-multicast-group-sources \
    --transit-gateway-multicast-domain-id tgw-mcast-domain-12345]
    --group-ip-address 239.0.0.1 \
    --network-interface-ids eni-1234 eni-12345
    ```

With this, the deployment of the AWS transit gateway multicast demo is completed!

## Testing the multicast group

After the setup is complete it is time to test it. In this demo, the use of [iPerf](https://iperf.fr/) tool for testing is described. *iPerf* should be installed on source and receiver instances. Connect to the Ubuntu Linux based instances over SSH and install the tool with `sudo apt-get install iperf`. Notice that the custom security group created allows the UDP transport protocol on port 5001 which is the default port used by iPerf.
After the installation on all instances, go to the multicast receiver instances and set them in server mode for the multicast group *239.0.0.1* (IP address set in step 6 of deployment) using UDP:

```
iperf -s -u -B 239.0.0.1 -i 1
```

This way the iPerf recognizes the multicast IP address and waits for the incoming UDP traffic on port 5001.

The only thing left is for the source to send the traffic to the multicast IP address. On the multicast source instance, start the iPerf in client mode against the same multicast group.

```
iperf -c 239.0.0.1 -u -T 32 -t 3 -i 1
```

The traffic will be generated and sent to the multicast group 239.0.0.1 over UDP to port 5001. While this is happening you can switch back to the receiving multicast instances that are waiting for the traffic and check that the traffic is received at the same time.

## Destroying the Infrastructure

As you created the infrastructure using a combination of Terraform and AWS CLI, and added numerous dependencies not known to Terraform, it takes several CLI commands to destroy the infrastructure:

1. Deregister sources and group members:

    ``` 
    aws ec2 deregister-transit-gateway-multicast-group-sources \
    --transit-gateway-multicast-domain-id tgw-mcast-domain-12345 \
    --group-ip-address 239.0.0.1 \
    --network-interface-ids eni-1234 eni-12345

    aws ec2 deregister-transit-gateway-multicast-group-members \
    --transit-gateway-multicast-domain-id tgw-mcast-domain-12345 \
    --group-ip-address 239.0.0.1 \
    --network-interface-ids eni-1234 eni-12345
    ```

2. Disassociate VPC/subnet attachments from transit gateway domain. Repeat this step for each association (each subnet)

    ```
    aws ec2 disassociate-transit-gateway-multicast-domain \
    --transit-gateway-multicast-domain-id tgw-mcast-domain-12345 \
    --transit-gateway-attachment-id tgw-attach-12345 \
    --subnet-id subnet-12345
    ```

3. Delete the transit gateway multicast domain.

    ```
    aws ec2 delete-transit-gateway-multicast-domain --transit-gateway-multicast-domain-id tgw-mcast-domain-12345
    ```

4. Destroy the infrastructure/resources created with Terraform using `terraform destroy`. By this time, no associations to AWS CLI created resources should remain.

5. Finally, delete the transit gateway.

    ```
    aws ec2 delete-transit-gateway --transit-gateway-id tgw-12345
    ```

