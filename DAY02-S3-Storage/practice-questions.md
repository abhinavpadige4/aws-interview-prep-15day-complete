# Day 2: S3 Practice Questions

## Multiple Choice Questions

### Question 1: What is the default storage class for S3?
A) S3 Standard-IA
B) S3 Standard
C) S3 One Zone-IA
D) S3 Intelligent-Tiering

**Correct Answer: B**

**Explanation**:
S3 Standard is the default storage class when no storage class is explicitly specified during object upload. It's designed for general-purpose storage of frequently accessed data with 99.99% availability and 99.999999999% durability.

### Question 2: How does S3 provide read-after-write consistency?
A) Through immediate propagation to all regions
B) By locking the object during write operations
C) For PUTS of new objects in any region
D) Using versioning to track all changes

**Correct Answer: C**

**Explanation**:
S3 provides read-after-write consistency for PUTS of new objects in any region. This means that immediately after successfully writing a new object to S3, you can read that object and get the updated version. For overwrite PUTS and DELETES, S3 now provides strong consistency (as of December 2020).

### Question 3: What is the maximum size of a single S3 object?
A) 5 GB
B) 100 GB
C) 5 TB
D) Unlimited

**Correct Answer: C**

**Explanation**:
The maximum size of a single S3 object is 5 terabytes (TB). For objects larger than 100 MB, AWS recommends using multipart upload. Objects up to 5 GB can be uploaded in a single operation, while larger objects must use multipart upload.

### Question 4: Which S3 feature protects against accidental deletion?
A) Versioning
B) Cross-region replication
C) Lifecycle policies
D) Bucket policies

**Correct Answer: A**

**Explanation**:
Versioning protects against accidental deletion by preserving every version of every object in the bucket. When versioning is enabled and you delete an object, S3 inserts a delete marker rather than removing the object permanently. You can restore previous versions by removing the delete marker or copying a previous version.

### Question 5: How can you serve static website content from S3?
A) Enable static website hosting on the bucket properties
B) Configure CloudFront distribution pointing to S3 bucket
C) Set bucket policy to allow public read access
D) Both A and C

**Correct Answer: D**

**Explanation**:
To serve static website content from S3:
1. Enable static website hosting in bucket properties (specify index and error documents)
2. Configure bucket policy to allow public read access to the objects
3. Optionally use CloudFront for CDN caching and custom domains
4. The website endpoint will be: `bucket-name.s3-website-region.amazonaws.com`

## Additional Practice Questions

### Question 6: What happens when you enable S3 Intelligent-Tiering?
A) Objects are automatically moved between frequent and infrequent access tiers
B) Objects are encrypted with AWS KMS keys
C) Objects are replicated to all AWS regions
D) Objects are compressed to save storage space

**Correct Answer: A**

**Explanation**:
S3 Intelligent-Tiering automatically moves objects between two access tiers (frequent and infrequent) based on changing access patterns. There are no retrieval fees when objects are accessed in the infrequent access tier. A small monthly monitoring and automation fee applies per object.

### Question 7: Which of the following is TRUE about S3 bucket naming?
A) Bucket names must be unique across all AWS accounts globally
B) Bucket names can contain uppercase letters
C) Bucket names can be changed after creation
D) Bucket names must start with a number

**Correct Answer: A**

**Explanation**:
S3 bucket names must be globally unique across all AWS accounts and all regions. This is because S3 uses a shared namespace. Bucket names:
- Must be between 3 and 63 characters long
- Can contain lowercase letters, numbers, periods, and hyphens
- Cannot begin or end with a period or hyphen
- Cannot contain two consecutive periods
- Cannot be changed after creation (you must create a new bucket and copy objects)

### Question 8: What is the maximum number of S3 buckets you can create by default per AWS account?
A) 50
B) 100
C) 200
D) 1000

**Correct Answer: B**

**Explanation**:
By default, you can create up to 100 S3 buckets per AWS account. This is a soft limit that can be increased by requesting a limit increase through AWS Support. Each bucket can store an unlimited number of objects.

### Question 9: How does S3 charge for data transfer?
A) Free for all data transfer
B) Charges for data IN to S3, free for data OUT
C) Free for data IN to S3, charges for data OUT to internet
D) Charges for both data IN and data OUT

**Correct Answer: C**

**Explanation**:
S3 data transfer pricing:
- **Data IN**: Free (no charge for uploading data to S3)
- **Data OUT**: Charged for data transferred from S3 to the internet
- **Data Between AWS Services**: Free within same region, charged between regions
- **Data Transfer Acceleration**: Additional charge for using S3 Transfer Acceleration endpoint

### Question 10: What is the purpose of S3 Object Lock?
A) To encrypt objects with customer-managed keys
B) To prevent objects from being deleted or overwritten for a fixed period
C) To automatically compress objects to save storage space
D) To replicate objects to multiple regions simultaneously

**Correct Answer: B**

**Explanation**:
S3 Object Lock enables WORM (Write Once, Read Many) storage model to:
- Prevent objects from being deleted or overwritten for a fixed period or indefinitely
- Help comply with regulatory requirements that require WORM storage
- Provide two modes: Governance (users with special permissions can override) and Compliance (protection cannot be overridden)
- Work with versioning to protect specific versions of objects

## Answer Key
1. B
2. C
3. C
4. A
5. D
6. A
7. A
8. B
9. C
10. B