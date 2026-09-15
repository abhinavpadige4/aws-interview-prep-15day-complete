# Day 3: VPC Networking

## Learning Objectives
- Understand VPC core concepts and components
- Learn about subnets, route tables, and gateways
- Master NAT gateways, VPC peering, and connectivity options
- Understand network ACLs vs security groups

## Key Concepts

### VPC Basics
- **Virtual Private Cloud (VPC)**: Logically isolated section of AWS Cloud
- **IP Address Range**: Defined by CIDR block (e.g., 10.0.0.0/16)
- **Isolation**: Resources in VPC are isolated from other AWS networks
- **Customization**: Full control over IP addressing, subnets, routing, and security

### VPC Limits (Default)
- **VPCs per region**: 5 (soft limit)
- **Subnets per VPC**: 200 (soft limit)
- **IPv4 CIDR blocks per VPC**: 5 (soft limit)
- **IPv6 CIDR blocks per VPC**: 5 (soft limit)
- **Route tables per VPC**: 200 (soft limit)
- **Security groups per VPC**: 500 (soft limit)
- **Network ACLs per VPC**: 200 (soft limit)

### VPC Components

#### 1. Subnets
- **Definition**: Range of IP addresses in your VPC
- **Types**:
  - **Public Subnet**: Has route to Internet Gateway
  - **Private Subnet**: No direct route to Internet Gateway
  - **VPN-only Subnet**: Has route to Virtual Private Gateway only
- **AZ Scope**: Each subnet resides in a single Availability Zone
- **Best Practice**: Use /24 subnets (256 addresses) for most workloads

#### 2. Route Tables
- **Definition**: Set of rules (routes) that determine where network traffic is directed
- **Main Route Table**: Automatically created with VPC
- **Custom Route Tables**: User-created for specific subnet routing needs
- **Routes**: Destination (CIDR) → Target (gateway, instance, etc.)
- **Local Route**: Automatically added for VPC internal communication

#### 3. Internet Gateway (IGW)
- **Purpose**: Enables communication between VPC and internet
- **Attributes**: Horizontally scaled, redundant, highly available
- **Attachment**: One IGW per VPC (can detach and attach to different VPC)
- **Routing**: Public subnets route 0.0.0.0/0 to IGW

#### 4. NAT Gateway / NAT Instance
- **Purpose**: Enable private subnet instances to initiate outbound IPv4 traffic
- **NAT Gateway**:
  - AWS managed, highly available
  - Pay per hour + data processed
  - Supports bursts up to 10 Gbps
  - Automatically scales based on traffic
- **NAT Instance**:
  - User-managed EC2 instance
  - Requires manual scaling and patching
  - Less expensive for low traffic, more management overhead

#### 5. Virtual Private Gateway (VGW)
- **Purpose**: Anchor for VPN connections between VPC and on-premises network
- **Attachment**: One VGW per VPC (can attach multiple VPN connections)
- **Alternatives**: AWS Direct Connect, Transit Gateway

#### 6. Egress-Only Internet Gateway (IPv6 only)
- **Purpose**: Enable outbound-only IPv6 communication for instances in VPC
- **IPv4 Equivalent**: NAT Gateway (but NAT Gateway also allows inbound with port forwarding)

### VPC Peering
- **Definition**: Direct network route between two VPCs for private traffic
- **Types**:
  - **Same-account peering**: VPCs in same AWS account
  - **Cross-account peering**: VPCs in different AWS accounts
  - **Same-region peering**: VPCs in same region
  - **Cross-region peering**: VPCs in different regions
- **Limitations**:
  - No transitive peering (A-B and B-C peered doesn't mean A-C peered)
  - Cannot have overlapping CIDR blocks
  - Bandwidth limited by instance bandwidth
  - No encryption (travels over AWS backbone, not public internet)

### VPN Connections
- **Types**:
  - **AWS Site-to-Site VPN**: IPsec tunnel between VPC and customer gateway
  - **AWS Client VPN**: Client-based VPN for individual users
- **Components**:
  - **Virtual Private Gateway**: VPN concentrator on AWS side
  - **Customer Gateway**: Represents customer's VPN device
  - **VPN Connection**: Links VGW and CGW
- **Options**:
  - **Static Routing**: Manually configured routes
  - **Dynamic Routing**: BGP for automatic route exchange
  - **Tunnel Options**: Two tunnels for high availability

### AWS Direct Connect
- **Purpose**: Dedicated network connection from on-premises to AWS
- **Benefits**:
  - Consistent network performance
  - Lower latency
  - Reduced network costs
  - Improved security (private connection)
- **Components**:
  - **Dedicated Connection**: 1Gbps or 10Gbps port
  - **Hosted Connection**: Resold capacity from AWS Direct Connect Partners
  - **Virtual Interface (VIF)**: Logical connection (public, private, transit)

### Transit Gateway
- **Purpose**: Hub-and-spoke model for connecting VPCs and on-premises networks
- **Benefits**:
  - Simplifies complex network architectures
  - Reduces operational overhead
  - Enables transitive routing (with route tables)
  - Scales to thousands of attachments
- **Components**:
  - **Transit Gateway**: Central hub
  - **Attachments**: VPCs, VPNs, Direct Connect, peering connections
  - **Route Tables**: Control traffic flow between attachments

### Networking Components Comparison

#### Network ACLs vs Security Groups
| Feature | Network ACLs | Security Groups |
|---------|--------------|-----------------|
| **Level** | Subnet level | Instance level |
| **Statefulness** | Stateless | Stateful |
| **Rule Evaluation** | Ordered (lowest number first) | All rules evaluated |
| **Default Rule** | Deny all | Allow all outbound, deny all inbound |
| **Number of Rules** | ~20 inbound/outbound | ~60 inbound/outbound |
| **Changes Apply** | Immediately | Immediately |
| **Use Case** | Subnet-level traffic control | Instance-level access control |

#### Route Tables vs Route Propagation
- **Route Tables**: Explicitly defined routes
- **Route Propagation**: Automatic route learning (VPN, Direct Connect, Transit Gateway)

### VPC Flow Logs
- **Purpose**: Capture information about IP traffic going to/from network interfaces
- **Capture Options**:
  - **Accepted traffic**: Only allowed traffic
  - **Rejected traffic**: Only blocked traffic
  - **All traffic**: Both accepted and rejected
- **Destinations**:
  - **CloudWatch Logs**: For monitoring and alerting
  - **S3**: For long-term storage and analysis
- **Levels**:
  - **VPC level**: All interfaces in VPC
  - **Subnet level**: All interfaces in subnet
  - **Network Interface level**: Specific ENI

### Elastic IP Addresses (EIP)
- **Purpose**: Static IPv4 address for dynamic cloud computing
- **Characteristics**:
  - Allocated to AWS account, not specific resource
  - Can be associated/disassociated with resources
  - Limited to 5 per region (soft limit)
  - Charges apply when not associated with running instance
- **Use Cases**:
  - Failover scenarios (reassign EIP to standby instance)
  - Whitelisting in firewalls
  - DNS A records for consistent endpoint

### Elastic Network Interfaces (ENI)
- **Purpose**: Virtual network interface for attaching to instances
- **Attributes**:
  - Primary private IPv4 address
  - One or more secondary private IPv4 addresses
  - Elastic IP address (IPv4)
  - One public IPv4 address
  - One or more IPv6 addresses
  - MAC address
  - Security groups
  - Source/destination check flag
- **Types**:
  - **Primary ENI**: Created automatically with instance
  - **Secondary ENI**: User-created and attached
- **Limits**: Varies by instance type

## Best Practices
- Plan IP addressing carefully (consider future growth)
- Use multiple AZs for high availability
- Separate public and private subnets clearly
- Use NAT Gateways for private subnet internet access
- Implement least privilege security groups
- Use network ACLs for subnet-level defense in depth
- Enable VPC Flow Logs for monitoring and troubleshooting
- Tag resources for cost allocation and management
- Use VPC endpoints for private access to AWS services
- Consider Transit Gateway for complex multi-VPC architectures

## Common VPC Issues
- **Cannot reach internet**: Missing or incorrect route to IGW/NAT
- **Cannot reach instance**: Security group blocking required ports
- **Asymmetric routing**: Return traffic taking different path
- **NAT Gateway limits**: Exceeding bandwidth or connection limits
- **Overlapping CIDR blocks**: Prevents VPC peering or VPN connections
- **DNS resolution issues**: VPC DNS settings or resolver configuration
- **MTU problems**: Jumbo frames or path MTU discovery issues

## Next Steps
- Practice creating VPCs with public and private subnets
- Experiment with NAT Gateways and bastion hosts
- Try VPC peering between different accounts/regions
- Work with AWS Direct Connect or VPN connections
- Explore Transit Gateway for hub-and-spoke architectures
- Use VPC Flow Logs for network monitoring and troubleshooting