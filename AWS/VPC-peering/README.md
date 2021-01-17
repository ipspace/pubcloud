# Inter-Region VPC Peering Example

_This example has been created [by Miha Markočič](https://www.ipspace.net/Team:Miha_Markocic)_

In this example, a VPC peering connection is established between two VPCs in different regions - also known as *inter-region VPC peering connection*. Peering is a networking connection between two VPCs that enables you to route the traffic between them using private IPv4 and/or IPv6 addresses. With such connection instances in either VPC can communicate with each other as if they are in the same network. 

## Details

This demo consists of two VPCs deployed in a different region (*eu-west-2 and eu-west-3*). Within each VPC, there are two subnets, to which custom route table and internet gateway are attached. Apart from enabling subnets to access the internet through the gateway, additional peering routes are configured through peering connection for subnets to access the VPC in another region. Each subnet consists of one webserver instance used to test the VPC peering connection.

[*main.tf*](main.tf) is the main Terraform file with general variables, outputs and modules used to create VPC peering. As the infrastructure for the inter-region peering requires resources to be created within different regions, the provider was specified within each module! The *main.tf* file uses the same module -- once for each region -- making the modules reusable across multiple regions. The only exception is the peering module, where unique peering connection and routes specific for the region had to be configured. 

## Network Module

The [Network](modules/network) module:

1. Defines the region where network infrastructure should be deployed! 
2. Creates a VPC 
3. Creates two public subnets
4. Creates an internet gateway and a route table.
5. Associates both subnets with the route table to enable outgoing Internet access
6. Creates custom Security group *(SSH<sup>1</sup> from anywhere, HTTP from both VPCs; all outbound traffic allowed)* 

---

<sup>1</sup> SSH traffic to your subnet should be allowed only from your IP address or IP address range.

## Peering Module

The [Peering](modules/peering) module:

1. Defines both AWS regions used as they are needed to create a connection on both "sides" of the peering
2. Creates requester's side of VPC peering connection to request the peering
3. Creates the accepter's side of VPC peering connection to accept the peering
4. Defines peering route on the requester's route table pointing to accepter's VPC CIDR block and vice versa

## Compute Module

The [Compute](modules/compute) module:

1. Obtains AWS AMI ID for the desired OS *(Ubuntu Server 20.04 LTS from Canonical)* in a defined region
2. Deploys a server instance in subnet A, associates it with the custom security group, and provisions Apache web server with *remote-exec* provisioner
3. Repeating the same steps, deploys another server instance in subnet B

## Testing the connection

Apart from Terraform files and modules to build the VPC peering infrastructure, this repository includes also a short  [*connection_test*](connection_test.yml) Ansible Playbook to test the VPC peering connections between VPC instances.

In order to gather the EC2 instances deployed with Terraform, [*aws_ec2*](aws_ec2.yml) plugin is used to create dynamic Ansible inventory. Once the infrastructure is deployed, you can inspect what is the output of *aws_ec2* plugin by executing the following command in the terminal:

```
ansible-inventory -i aws_ec2.yml --list --yaml
```

Ansible playbook is executed on all 4 hosts (webservers) simultaneously, testing the connection to other instances over the private IPs on port 80. To run *connection_test* the following commands should be executed from the terminal:

- Ansible enables host key checking by default, which guards against spoofing and man-in-the-middle attacks! If a new host is not in *'known_hosts'* your control may prompt for confirmation. If you do not want this and understand the implications you can *disable host key checking* by setting an environment variable:

```
export ANSIBLE_HOST_KEY_CHECKING=False
```

- You can also change the corresponding settings in *ansible.cfg* file:

    ```
    [defaults]
    host_key_checking = False
    ```

- The command to run the Ansible playbook should include the *username* to log in to each instance, *Key location* for the SSH connection and *inventory file* which is in our case *aws_ec2* plugin and the playbook file:

    ```
    ansible-playbook -u *username* --private-key *path/to/your/sshkey* -i aws_ec2.yml connection_test.yml
    ```

Ansible playbook connects over SSH to each EC2 instance, and tries to reach other instances over private IPs on port 80. For that purpose, the security group of webservers allows only SSH inbound traffic from "outside", while HTTP traffic is allowed from within both VPCs. If there are no errors during the deployment, the playbook should finish successfully after testing a full mesh of inter-server connections.
