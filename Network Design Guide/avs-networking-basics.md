# Azure VMware Solution Networking basics
This section summarizes some fundamental concepts about Azure VMware Solution networking. They are a pre-requisite for understanding the design options covered in the following sections and for designing complex Azure VMware Solution topologies.

## What   is the role played by ExpressRoute?
Azure VMware Solution runs on bare-metal VMWare ESXi nodes deployed in Azure datacenters and attached to a physical network. Just like Expressroute circuits allow Azure customers to establish layer-3 connectivity between their physical datacenter networks and Azure VNets, a dedicated Expressroute implementation provides layer-3 connectivity between physical ESXi nodes and Azure VNets. 
When an Azure VMware Solution Private Cloud is provisioned, an associated Expressroute circuit is also instantiated in a Microsoft-managed subscription. The private cloud’s owner can connect the circuit to one or more Expressroute virtual network gateways in  Azure VNets, by redeeming authorization keys for the circuit (the same procedure used to create connections between Expressroute gateways and customer-managed circuits). Please refer to the [Azure VMware Solution official documentation](https://learn.microsoft.com/azure/azure-vmware/deploy-azure-vmware-solution?tabs=azure-portal#connect-to-azure-virtual-network-with-expressroute ) for detailed instructions.
 
![figure2](media/figure2.png) 
Figure 2. Azure VMware Solution leverages a dedicated Expressroute implementation to provide layer-3 connectivity between Azure VNets and the physical network to which the VMWare ESXi clusters are attached. The VMware ESXi clusters are hosted in the same Microsoft datacenter facilities that host the Azure platform.

## What is the role played by Expressroute Global Reach?
An Azure Expressroute Gateway cannot be used to route traffic between on-prem locations connected to it over different circuits. This limitation applies to the Azure VMware Solution dedicated Expressroute implementation too, as shown in the figure below.
 
![figure3](media/figure3.png) 
Figure 3. ExpressRoute does not support routing traffic between different circuits connected to the same gateway.

Global Reach is an Expressroute feature that allows connecting two circuits, so that the networks connected to each circuit can route traffic to each other over the Microsoft backbone. Global Reach is available in the Azure VMware Solution dedicated Expressroute implementation. As such, Azure VMware Solution managed Expressroute circuits can be connected to customer-managed circuits, providing layer-3 connectivity between on-prem networks and Azure VMware Solution private clouds.
 
![figure4](media/figure4.png) 
Figure 4. ExpressRoute Global Reach provides direct, layer-3 connectivity over ExpressRoute for on-prem sites.

## Azure VMware Solution network topology
An Azure VMware Solution private cloud infrastructure includes several network segments. 
- Management networks support  basic vSphere cluster functions (vCenter Server and NSX-T management VMs, vMotion, replication, vSAN, …). The management networks’ address space is allocated from the /22 address block assigned to each Azure VMware Solution private cloud at provisioning time. See the [Azure VMware Solution official documentation](https://learn.microsoft.com/azure/azure-vmware/tutorial-network-checklist#routing-and-subnet-considerations) for details on how IP address ranges from the /22 block are assigned to management networks. 
- Workload segments are customer-defined NSX-T segments to which Azure VMware Solution virtual machines attach. The address range for a workload segment is customer-defined. It cannot overlap with the Azure VMware Solution private cloud’s /22 management block, nor with any other address range used in Azure VNets or remote networks connected to the private cloud that must be reachable from the segment. 

## Dynamic routing in Azure VMware Solution
Azure VMware Solution private clouds connect to Azure VNets and remote sites over the managed Expressroute circuit. BGP is used for dynamic route exchange, as shown in the figure below.
 
![figure5](media/figure5.png) 
Figure 5. Dynamic routing in Azure VMware Solution.

In the standard topology shown in Figure 5:
- Routes for all network segments in the Azure VMware Solution private cloud (both management and workload segments) are announced to all Expressroute Gateways connected to the private cloud’s managed circuit. In the opposite direction, Expressroute Gateways announce routes for all the prefixes that comprise the address space of their own VNet and the address space of all directly peered VNets, if peering is configured to [allow gateway transit](https://learn.microsoft.com/azure/virtual-network/virtual-network-peering-overview#gateways-and-on-premises-connectivity) (red arrow in Figure 5). 
- Routes for all network segments in the Azure VMware Solution private cloud (both management and workload segments) are announced to all Expressroute circuits connected to the private cloud’s managed circuit via Global Reach. In the opposite direction, all routes announced from the on-prem site over the customer-managed Expressroute circuit are propagated to the Azure VMware Solution private cloud (yellow arrow in Figure 5).
- All routes announced from the on-prem site over the customer-managed Expressroute circuit are learned by all Expressroute Gateways connected to the circuit and injected the route table of the gateway’s VNet (as well as the route table of all directly peered VNets, if peering is configured to [allow gateway transit](https://learn.microsoft.com/azure/virtual-network/virtual-network-peering-overview#gateways-and-on-premises-connectivity)). In the opposite direction, Expressroute Gateways announce routes for all the prefixes that comprise the address space of their own VNet (as well as the address space of all directly peered VNets, if peering is configured to [allow gateway transit](https://learn.microsoft.com/azure/virtual-network/virtual-network-peering-overview#gateways-and-on-premises-connectivity)) (green arrow in Figure 5. This is standard Expressroute behavior, not related to Azure VMware Solution). 

It should be noted that Expressroute gateways do not propagate routes across circuit connections. In Figure 5, the Expressroute Gateway does not propagate routes learned in the “red” BGP session to the “green” BGP peer, and vice versa. This is the reason why Global Reach is required to enable connectivity between the Azure VMware Solution private cloud and the on-prem site.

## Next Steps
- Go back to the Azure VMware Solution Network Design Guide [introduction](readme.md).
- Go to the next section to learn about [connectivity between Azure VMware Solution and on-prem sites](onprem-connectivity.md) 