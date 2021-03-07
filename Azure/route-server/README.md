# Testing Azure Route Server

The scripts in this directory test Azure Route Server (preview) functionality in a virtual network with two subnets, three virtual machines (two NVA instances running Quagga and a back-end VM) and a user-defined route table.

## Set up the environment

* Open Azure Shell
* From home directory clone https://github.com/ipspace/azure.git  (basic test scripts from [Microsoft Azure Networking](https://www.ipspace.net/Microsoft_Azure_Networking) webinar) and https://github.com/ipspace/pubcloud.git (scripts from [Networking in Public Cloud Deployments](https://www.ipspace.net/PubCloud/) online course, including advanced AWS and Azure functionality)
* Create resource group **rs**

```
azure/setup/create-rg rs
```

* Create virtual network and virtual machines

```
pubcloud/Azure/route-server/create-vnet.sh
pubcloud/Azure/route-server/create-vm.sh
```

* (Optional) Create user-defined route table and apply it to the Internal subnet

```
pubcloud/Azure/route-server/create-rt.sh
```

* Get the IP address of the web VM and test SSH access (this will also collect SSH keys)

```
. azure/setup/get-public NVA_1
ssh azure@$NVA_1
. azure/setup/get-public NVA_2
ssh azure@$NVA_2
```

* Install and start Quagga on NVA virtual machines

```
pubcloud/Azure/route-server/install-quagga.sh
```

**Note:** Quagga configuration files are in the **route-server** directory. You could change them before deploying Quagga, or use **sudo vtysh** when logged into NVA virtual machines to configure running Quagga instances.

## Create route server

* Create route server instance

```
pubcloud/Azure/route-server/create-rs.sh
```

* Configure BGP peering between route server instances and your NVA virtual machines

```
pubcloud/Azure/route-server/config-peering.sh
```

## Inspect received routes

```
az network routeserver peering list-learned-routes \
  --resource-group rs \
  --routeserver RouteServer \
  --name NVA_1
az network routeserver peering list-learned-routes \
  --resource-group rs \
  --routeserver RouteServer \
  --name NVA_2
```

## Inspect effective routes at backend VM

```
az network nic show-effective-route-table \
  --resource-group rs --name BackendVMNic -o table
```

## Cleanup

Run the cleanup script to remove route server peering and route server instance, then the generic cleanup script that deletes the resource group, effectively removing all RG-related resources.

```
pubcloud/Azure/route-server/cleanup.sh
azure/setup/delete-rg
```

**Warning:** As of early March 2021, removing a resource group does NOT remove the route server instance and dependent objects (route table, virtual network). It's also impossible to delete route server from Azure portal. Make sure you run the route server cleanup script first.
