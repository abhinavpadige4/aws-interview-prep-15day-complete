# Day 1: EC2 Practice Questions

## Multiple Choice Questions

### Question 1: What is the difference between stop and terminate an EC2 instance?
A) Stop preserves EBS volumes, terminate deletes them
B) Stop is temporary, terminate is permanent
C) Stop incurs no charges, terminate incurs charges
D) Both A and B

**Correct Answer: D**

**Explanation**: 
- When you stop an instance, the EBS root device persists, allowing you to start it again later
- When you terminate an instance, the EBS root device is deleted by default (unless deleteOnTermination=false)
- Stopped instances don't incur compute charges but do incur storage charges for EBS volumes
- Terminated instances cannot be restarted

### Question 2: How can you assign an Elastic IP to an instance?
A) Through the EC2 console under Elastic IPs → Allocate new address
B) By modifying the instance's network interface settings
C) Using the AWS CLI command `aws ec2 associate-address`
D) All of the above

**Correct Answer: D**

**Explanation**:
Elastic IPs can be assigned through multiple methods:
- AWS Console: EC2 Dashboard → Elastic IPs → Allocate new address → Associate with instance
- Network Interface: Select ENI → Actions → Associate address
- AWS CLI: `aws ec2 associate-address --instance-id i-xxxx --allocation-id eipalloc-xxxx`
- AWS SDKs and CloudFormation

### Question 3: Which EC2 purchasing option offers the highest discount?
A) On-Demand Instances
B) Reserved Instances (1-year term)
C) Reserved Instances (3-year term)
D) Spot Instances

**Correct Answer: D**

**Explanation**:
- Spot Instances can offer up to 90% discount compared to On-Demand pricing
- Reserved Instances typically offer 40-60% discount (depending on term and payment option)
- On-Demand has no discount (pay-as-you-go)
- Spot Instances are ideal for fault-tolerant, flexible workloads

### Question 4: What is the default limit for security groups per region?
A) 500 security groups per region
B) 1000 security groups per region
C) 250 security groups per region
D) 50 security groups per region

**Correct Answer: A**

**Explanation**:
The default limit is 500 security groups per AWS region. This is a soft limit that can be increased by requesting a limit increase through AWS Support. Each security group can have up to 60 inbound and 60 outbound rules.

### Question 5: How do you enable detailed monitoring on an EC2 instance?
A) Through CloudWatch console → Metrics → Enable detailed monitoring
B) During instance launch → Monitoring section → Enable detailed monitoring
C) Using AWS CLI: `aws ec2 monitor-instances --instance-ids i-xxxx`
D) Both B and C

**Correct Answer: D**

**Explanation**:
Detailed monitoring provides 1-minute granularity (vs 5-minute for basic monitoring):
- Can be enabled during instance launch in the "Monitoring" section
- Can be enabled/disabled after launch using AWS CLI or Console
- AWS CLI command: `aws ec2 monitor-instances --instance-ids i-xxxx`
- To disable: `aws ec2 unmonitor-instances --instance-ids i-xxxx`
- Additional charges apply for detailed monitoring

## Additional Practice Questions

### Question 6: What happens to the data on instance store volumes when an EC2 instance is stopped?
A) Data is preserved
B) Data is lost
C) Data is moved to EBS
D) Data is snapshotted

**Correct Answer: B**

**Explanation**: Instance store volumes are ephemeral storage that is physically attached to the host machine. When an instance is stopped, the underlying host may change, resulting in loss of all data on instance store volumes.

### Question 7: Which of the following is TRUE about Amazon Machine Images (AMIs)?
A) AMIs are region-specific
B) AMIs cannot be shared between AWS accounts
C) AMIs always include the operating system
D) AMIs cannot be copied between regions

**Correct Answer: A**

**Explanation**: AMIs are region-specific resources. To use an AMI in another region, you must copy it to that region first. AMIs can be shared between AWS accounts (with appropriate permissions) and always include an operating system plus any additional software configured.

### Question 8: What is the maximum number of Elastic Network Interfaces (ENIs) you can attach to a T3.medium instance?
A) 2
B) 3
C) 4
D) Depends on the instance type

**Correct Answer: D**

**Explanation**: The maximum number of ENIs varies by instance type. For T3.medium, it's 3 ENIs (1 primary + 2 secondary). Always check the specific instance type documentation for ENI limits.

### Question 9: When using an IAM role with an EC2 instance, where are the credentials stored?
A) In the instance's user data
B) In the instance metadata service
C) In environment variables
D) In a credentials file on the instance

**Correct Answer: B**

**Explanation**: IAM roles for EC2 instances use the instance metadata service (IMDS) to provide temporary credentials. Applications can retrieve credentials from `http://169.254.169.254/latest/meta-data/iam/security-credentials/role-name`. No credentials are stored on the instance itself.

### Question 10: What is the purpose of EC2 Placement Groups?
A) To group instances for billing purposes
B) To control the placement of instances for specific networking or performance needs
C) To automatically scale instances based on demand
D) To encrypt data at rest on EBS volumes

**Correct Answer: B**

**Explanation**: Placement groups influence the placement of instances to meet specific needs:
- Cluster: Low network latency, high throughput (for HPC applications)
- Spread: Reduced risk of simultaneous failure (critical instances separated)
- Partition: For large distributed workloads (HDFS, Cassandra, Kafka)

## Answer Key
1. D
2. D
3. D
4. A
5. D
6. B
7. A
8. D
9. B
10. B