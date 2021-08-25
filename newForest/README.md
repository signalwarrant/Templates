# Create a new Active Directory Forest

- Single Server 2022 Datacenter smalldisk DC in an Availability Set
- Create X number of domain joined Server 2022 VMs
- Create X number of domain joined Server 2019 VMs
- Create X number of domain joined Windows 10 VMs
- All VMs are on the same VNET
- All VMs are protected by the same NSG (default rules)
  - no RDP allowed
- Bastion host is deployed for VM access


## Roadmap
- Hydrate AD with User / Group data via DSC
- Automation to teardown and build the Bastion host daily to save costs
- Are more NSG rules needed?