# Day 2: S3 Storage

## Learning Objectives
- Understand S3 core concepts and architecture
- Learn about S3 storage classes and use cases
- Master bucket policies, versioning, and lifecycle policies
- Understand static website hosting and cross-region replication

## Key Concepts

### S3 Basics
- **Simple Storage Service (S3)**: Object storage service for storing and retrieving data
- **Buckets**: Containers for objects (similar to folders/directories)
- **Objects**: Files stored in S3 (data + metadata)
- **Keys**: Unique identifiers for objects within a bucket
- **Regions**: S3 buckets are region-specific for data residency

### S3 Architecture
- **Eventually Consistent**: Read-after-write consistency for PUTS of new objects
- **Strong Consistency**: Read-after-write consistency for PUTS and DELETES (since Dec 2020)
- **High Availability**: 99.99% availability SLA
- **Durability**: 99.999999999% (11 nines) durability SLA
- **Scalability**: Virtually unlimited storage capacity

### S3 Storage Classes
1. **S3 Standard**: General purpose, 99.99% availability
2. **S3 Standard-IA (Infrequent Access)**: Lower cost for less frequently accessed data
3. **S3 One Zone-IA**: Single AZ, lower cost than Standard-IA
4. **S3 Intelligent-Tiering**: Automatic tiering based on access patterns
5. **S3 Glacier**: Low-cost archival (minutes to hours retrieval)
6. **S3 Glacier Deep Archive**: Lowest cost archival (hours to hours retrieval)

### Data Consistency Model
- **Read-after-write consistency**: For PUTS of new objects
- **Eventual consistency**: For overwrite PUTS and DELETES (now strong consistency)
- **Consistency across regions**: Eventually consistent for cross-region replication

### Bucket Operations
- **Create/Delete Buckets**: Regional scoped operations
- **List Objects**: paginated results (max 1000 per response)
- **Object Operations**: PUT, GET, COPY, DELETE
- **Multipart Upload**: For objects > 100MB (recommended > 5MB)

### Versioning
- **Enabled/Disabled/Suspended**: Bucket-level setting
- **Preserves**: Every version of every object
- **Use Cases**: Backup, recovery from accidental deletion/overwrite
- **Cost**: You pay for all versions stored
- **MFA Delete**: Additional protection for versioned buckets

### Lifecycle Policies
- **Transition Actions**: Move objects between storage classes
- **Expiration Actions**: Automatically delete objects
- **Rules**: Based on prefix, tags, or object size
- **Examples**: 
  - Move to Glacier after 30 days
  - Delete after 365 days
  - Move to IA after 60 days, then to Glacier after 365 days

### Access Control
- **Bucket Policies**: JSON-based, bucket-level permissions
- **ACLs (Access Control Lists)**: Legacy, object/bucket level
- **IAM Policies**: User/role-based permissions
- **Access Points**: Simplified access management for shared datasets
- **Block Public Access**: Security feature to prevent accidental public exposure

### Static Website Hosting
- **Endpoint**: `bucket-name.s3-website-region.amazonaws.com`
- **Supported**: HTML, CSS, JavaScript, client-side scripting
- **Not Supported**: Server-side scripting (PHP, ASP.NET, etc.)
- **Error Documents**: Custom 404 pages
- **Index Document**: Default page (usually index.html)

### Cross-Region Replication (CRR)
- **Automatic**: Asynchronous copying of objects
- **Requirements**: Versioning enabled on both buckets
- **Use Cases**: Compliance, latency reduction, disaster recovery
- **Cost**: You pay for storage, requests, and data transfer

### S3 Select & Glacier Select
- **Purpose**: Retrieve only specific data from objects
- **Benefits**: Reduced data transfer, improved performance
- **Supported Formats**: CSV, JSON, Apache Parquet
- **SQL Expressions**: Filter and project data using SQL

### Security Features
- **Encryption**: 
  - SSE-S3: Amazon S3-managed keys
  - SSE-KMS: AWS KMS-managed keys
  - SSE-C: Customer-provided keys
  - Client-side encryption
- **Access Logging**: Log all requests to a bucket
- **Audit Logging**: Track access with CloudTrail
- **VPC Endpoints**: Private access to S3 (no internet gateway needed)

## Best Practices
- Use appropriate storage class based on access patterns
- Enable versioning for critical data
- Use lifecycle policies to optimize costs
- Block public access unless specifically needed
- Use bucket policies for least privilege access
- Enable server access logging for audit trails
- Use S3 Batch Operations for large-scale changes
- Monitor usage with CloudWatch metrics
- Use S3 Inventory for auditing and reporting

## Common S3 Issues
- **Access Denied**: Check bucket policy, IAM permissions, ACLs
- **Slow Performance**: Consider S3 Transfer Acceleration or CloudFront
- **Unexpected Charges**: Review storage class usage, data transfer, requests
- **Replication Issues**: Verify versioning status, IAM role permissions
- **Website Not Loading**: Check index/error document configuration, public access blocks

## Next Steps
- Practice creating buckets with different configurations
- Experiment with lifecycle policies and storage class transitions
- Try setting up static website hosting
- Explore cross-region replication scenarios
- Work with S3 Select for querying object content