# Day 3: VPC Practice Questions

## Multiple Choice Questions

### Question 1: What is the CIDR block size limit for a VPC?
A) /16 to /28
B) /8 to /28
C) /16 to /24
D) No limit

**Correct Answer: B**

**Explanation**:
VPC CIDR blocks can range from /8 (16,777,216 addresses) to /28 (16 addresses). This provides flexibility for different workload sizes while maintaining practical limits. Remember that AWS reserves 5 IP addresses in each subnet (network address, broadcast address, and 3 for internal use).

### Question 2: How many subnets can you create per VPC by default?
A) 50
B) 100
C) 200
D) 500

**Correct Answer: C**

**Explanation**:
By default, you can create up to 200 subnets per VPC. This is a soft limit that can be increased by requesting a limit increase through AWS Support. Each subnet must reside in a single Availability Zone and cannot span multiple AZs.

### Question 3: What is the purpose of a NAT gateway?
A) To allow inbound traffic from the internet to private instances
B) To enable private subnet instances to initiate outbound IPv4 traffic
C) To provide DNS resolution for VPC resources
D) To encrypt traffic between VPC and on-premises networks

**Correct Answer: B**

**Explanation**:
A NAT gateway enables instances in private subnets to initiate outbound traffic to the internet or other AWS services, but prevents the internet from initiating connections with those instances. It's a managed, highly available service that scales automatically.

### Question 4: Difference between network ACL and security group?
A) NACL is stateful, security group is stateless
B) NACL operates at subnet level, security group at instance level
C) NACL filters outbound traffic, security group filters inbound traffic
D) NACL requires explicit allow rules, security group uses implicit deny

**Correct Answer: B**

**Explanation**:
- **Network ACLs**: Operate at subnet level, stateless (return traffic must be explicitly allowed), evaluated in order (lowest number first)
- **Security Groups**: Operate at instance level, stateful (return traffic automatically allowed), all rules evaluated, implicit deny for inbound traffic

### Question 5: How does VPC peering work?
A) Creates a direct network route between two VPCs for private traffic using AWS backbone
B) Uses internet gateways to route traffic between VPCs
C) Requires a VPN connection between the VPCs
D) Transfers data over the public internet with encryption

**Correct Answer: A**

**Explanation**:
VPC peering creates a direct network route between two VPCs using AWS's private backbone network. Traffic stays within the AWS global network and never traverses the public internet. It supports same-region and cross-region peering, but does not support transitive peering.

## Additional Practice Questions

### Question 6: What is the default tenancy option for instances launched in a VPC?
A) Dedicated
B) Host
C) Default
D) Shared

**Correct Answer: C**

**Explanation**:
The default tenancy option is "default", which means instances run on shared hardware. Other options include:
- **Dedicated**: Instances run on single-tenant hardware
- **Host**: Instances run on a specific Dedicated Host
Tenancy can be set at VPC level (applies to all instances) or overridden at instance launch.

### Question 7: Which of the following statements about VPC Flow Logs is TRUE?
A) Flow logs can only be delivered to CloudWatch Logs
B) Flow logs capture traffic at the subnet level only
C) Flow logs can capture accepted, rejected, or all traffic
D) Flow logs require an internet gateway to function

**Correct Answer: C**

**Explanation**:
VPC Flow Logs can capture:
- **Accepted traffic**: Only traffic that was allowed by security groups/NACLs
- **Rejected traffic**: Only traffic that was blocked by security groups/NACLs
- **All traffic**: Both accepted and rejected traffic
Flow logs can be delivered to CloudWatch Logs or S3, and can be configured at VPC, subnet, or network interface level.

### Question 8: What happens when you delete a subnet in a VPC?
A) The VPC is automatically deleted
B) Instances in the subnet are terminated
C) The subnet can be recovered within 24 hours
D) The IP address range is returned to the VPC for reuse

**Correct Answer: D**

**Explanation**:
When you delete a subnet:
- Any instances in the subnet must be terminated first
- The subnet is removed from the VPC
- The IP address range (CIDR block) of the subnet is returned to the VPC
- The address space can then be used to create new subnets
- Associated route tables, network ACLs, and security group references are updated

### Question 9: Which AWS service provides a dedicated network connection from on-premises to AWS?
A) AWS VPN
B) AWS Direct Connect
C) Amazon Connect
D) AWS Global Accelerator

**Correct Answer: B**

**Explanation**:
AWS Direct Connect provides a dedicated network connection from on-premises to AWS. Benefits include:
- Consistent network performance
- Lower latency compared to internet-based connections
- Reduced network costs for high-volume data transfer
- Improved security (private connection, not over public internet)
- Ability to partition connection into multiple virtual interfaces

### Question 10: What is the purpose of an Egress-Only Internet Gateway?
A) To allow inbound IPv6 traffic to VPC
B) To enable outbound-only IPv6 communication for instances in VPC
C) To provide NAT functionality for IPv4 traffic
D) To encrypt traffic leaving the VPC

**Correct Answer: B**

**Explanation**:
An Egress-Only Internet Gateway is used with IPv6 traffic to allow outbound-only communication from VPC instances to the internet, preventing the internet from initiating IPv6 connections with those instances. This is the IPv6 equivalent of a NAT gateway for IPv4 traffic.

## Answer Key
1. B
2. C
3. B
4. B
5. A
6. C
7. C
8. D
9. B
10. B