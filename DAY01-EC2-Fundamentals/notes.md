# Day 1: EC2 Fundamentals

## Learning Objectives
- Understand EC2 core concepts and terminology
- Learn about EC2 instance types and families
- Master AMIs, security groups, and key pairs
- Understand EC2 purchasing options and pricing

## Key Concepts

### EC2 Basics
- **Elastic Compute Cloud (EC2)**: Web service providing resizable compute capacity
- **Instances**: Virtual servers in the cloud
- **AMIs (Amazon Machine Images)**: Pre-configured templates for instances
- **Regions and Availability Zones**: Geographic distribution of AWS resources

### Instance Types
EC2 instances are categorized by workload optimization:
- **General Purpose**: T3, T3a, M5, M5a (balanced compute, memory, networking)
- **Compute Optimized**: C5, C5a, C6i (high-performance processors)
- **Memory Optimized**: R5, R5a, X1 (memory-intensive applications)
- **Storage Optimized**: I3, D3, H1 (high-speed local storage)
- **Accelerated Computing**: P3, G4, Inf1 (GPUs, FPGAs, specialized hardware)

### Instance Lifecycle
1. **Pending**: Instance is being launched
2. **Running**: Instance is operational
3. **Stopping**: Instance is being stopped
4. **Stopped**: Instance is stopped but EBS volumes persist
5. **Terminated**: Instance is permanently deleted

### Key EC2 Components
- **AMIs**: Templates containing OS, applications, configurations
- **Instance Types**: Determine hardware capabilities
- **Storage**: EBS volumes, Instance Store, EFS
- **Networking**: VPC, Subnets, Security Groups, Elastic IPs
- **Security**: Key pairs (SSH), Security Groups, IAM roles

### Security Groups
- Virtual firewalls controlling inbound/outbound traffic
- Stateful: Return traffic automatically allowed
- Rules evaluated in order
- Default: Allow all outbound, deny all inbound
- Can reference other security groups

### Key Pairs
- Used for SSH authentication to Linux instances
- Public key stored in AWS, private key downloaded by user
- Must be specified at launch time (cannot be added later for Linux)
- Windows instances use password instead of key pairs

### Elastic IP Addresses
- Static IPv4 addresses for dynamic cloud computing
- Associated with your AWS account, not a specific instance
- Can be remapped to different instances
- Limited to 5 per region (soft limit)

### EC2 Purchasing Options
1. **On-Demand**: Pay by the second, no commitment
2. **Reserved Instances**: 1-3 year commitment, significant discount
3. **Spot Instances**: Bid on spare capacity, up to 90% discount
4. **Dedicated Hosts**: Physical server dedicated for your use
5. **Dedicated Instances**: Instance isolated at hardware level

## Best Practices
- Use latest generation instance types for better price/performance
- Enable detailed monitoring for critical applications
- Use Auto Scaling groups for fault tolerance and scalability
- Regularly review and optimize instance sizes
- Use IAM roles instead of hardcoded credentials
- Enable termination protection for critical instances
- Tag resources for cost allocation and management

## Common EC2 Issues
- Connection timeout: Check security groups, NACLs, route tables
- Instance status checks failed: Underlying host or instance problems
- Unable to connect via SSH: Key pair issues, security group blocking port 22
- High CPU utilization: Consider larger instance type or optimize application

## Next Steps
- Practice launching different instance types
- Experiment with security group configurations
- Try connecting via SSH with different key pairs
- Explore EC2 pricing calculator for cost estimation