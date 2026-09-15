# Day 2: S3 Hands-on Exercise

## Objective
Create an S3 bucket, enable versioning, upload a file, set a lifecycle policy to transition to Glacier after 30 days, and configure static website hosting.

## Prerequisites
- AWS Free Tier account
- AWS CLI installed and configured
- Text editor
- Sample files to upload (we'll create some)

## Estimated Time: 60 minutes

## Step-by-Step Instructions

### Part 1: Preparation

#### Step 1: Create Sample Files
```bash
# Create directory for S3 exercises
mkdir -p ~/aws-exercises/s3
cd ~/aws-exercises/s3

# Create sample files for upload
cat > welcome.txt << 'EOF'
Welcome to AWS S3 Interview Preparation!
This file demonstrates S3 storage capabilities.
Uploaded on: $(date)
EOF

cat > index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>S3 Static Website Demo</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .container { max-width: 600px; margin: 0 auto; }
        .header { color: #ff9900; text-align: center; }
        .content { background: #f8f9fa; padding: 20px; border-radius: 8px; }
    </style>
</head>
<body>
    <div class="container">
        <h1 class="header">AWS S3 Static Website</h1>
        <div class="content">
            <p>This website is hosted entirely on Amazon S3!</p>
            <p>Features demonstrated:</p>
            <ul>
                <li>Static website hosting</li>
                <li>Versioning</li>
                <li>Lifecycle policies</li>
            </ul>
            <p>Last updated: <span id="date"></span></p>
        </div>
    </div>
    <script>
        document.getElementById('date').textContent = new Date().toLocaleDateString();
    </script>
</body>
</html>
EOF

cat > data.json << 'EOF'
{
  "exercise": "S3 Hands-on Practice",
  "date": "$(date)",
  "services": ["S3", "EC2", "VPC"],
  "difficulty": "intermediate",
  "topics": [
    "storage classes",
    "versioning",
    "lifecycle policies",
    "static website hosting"
  ]
}
EOF

ls -la
```

#### Step 2: Create S3 Bucket
```bash
# Generate unique bucket name (must be globally unique)
TIMESTAMP=$(date +%s)
BUCKET_NAME="aws-interview-s3-${TIMESTAMP}"
echo "Creating bucket: $BUCKET_NAME"

# Create bucket (us-east-1 doesn't need CreateBucketConfiguration)
aws s3api create-bucket \
    --bucket $BUCKET_NAME \
    --region us-east-1

echo "Bucket created: $BUCKET_NAME"

# Verify bucket creation
aws s3api head-bucket --bucket $BUCKET_NAME
```

#### Step 3: Enable Versioning
```bash
# Enable versioning on the bucket
aws s3api put-bucket-versioning \
    --bucket $BUCKET_NAME \
    --versioning-configuration Status=Enabled

echo "Versioning enabled for bucket: $BUCKET_NAME"

# Verify versioning status
aws s3api get-bucket-versioning --bucket $BUCKET_NAME
```

#### Step 4: Upload Files
```bash
# Upload sample files
echo "Uploading sample files..."

aws s3 cp welcome.txt s3://$BUCKET_NAME/welcome.txt
aws s3 cp index.html s3://$BUCKET_NAME/index.html
aws s3 cp data.json s3://$BUCKET_NAME/data.json

# Verify uploads
echo "Files in bucket:"
aws s3 ls s3://$BUCKET_NAME/

# Check object versions
echo "Object versions:"
aws s3api list-object-versions --bucket $BUCKET_NAME
```

#### Step 5: Set Lifecycle Policy
```bash
# Create lifecycle policy JSON
cat > lifecycle-policy.json << 'EOF'
{
    "Rules": [
        {
            "ID": "TransitionToGlacierAfter30Days",
            "Status": "Enabled",
            "Filter": {},
            "Transitions": [
                {
                    "Days": 30,
                    "StorageClass": "GLACIER"
                }
            ],
            "Expiration": {
                "Days": 365
            }
        }
    ]
}
EOF

# Apply lifecycle policy
aws s3api put-bucket-lifecycle-configuration \
    --bucket $BUCKET_NAME \
    --lifecycle-configuration file://lifecycle-policy.json

echo "Lifecycle policy applied: Transition to Glacier after 30 days, expire after 365 days"

# Verify lifecycle policy
aws s3api get-bucket-lifecycle-configuration --bucket $BUCKET_NAME
```

#### Step 6: Configure Static Website Hosting
```bash
# Create website configuration
cat > website-config.json << 'EOF'
{
    "IndexDocument": {
        "Suffix": "index.html"
    },
    "ErrorDocument": {
        "Key": "error.html"
    }
}
EOF

# Create a simple error page
cat > error.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Page Not Found - S3 Demo</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; margin-top: 50px; }
        .error-code { font-size: 80px; color: #ff9900; }
        .message { font-size: 24px; color: #666; }
    </style>
</head>
<body>
    <div class="error-code">404</div>
    <div class="message">Page not found</div>
    <div class="message">The page you're looking for doesn't exist.</div>
    <a href="index.html" style="color: #ff9900;">Return to Home</a>
</body>
</html>
EOF

# Upload error page
aws s3 cp error.html s3://$BUCKET_NAME/error.html

# Enable static website hosting
aws s3api put-bucket-website \
    --bucket $BUCKET_NAME \
    --website-configuration file://website-config.json

echo "Static website hosting enabled"

# Verify website configuration
aws s3api get-bucket-website --bucket $BUCKET_NAME

# Get website endpoint
WEBSITE_ENDPOINT="$BUCKET_NAME.s3-website-us-east-1.amazonaws.com"
echo "Website endpoint: http://$WEBSITE_ENDPOINT"
```

#### Step 7: Set Bucket Policy for Public Read Access
```bash
# Create bucket policy for public read access (needed for website)
cat > bucket-policy.json << EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::$BUCKET_NAME/*"
        }
    ]
}
EOF

# Apply bucket policy
aws s3api put-bucket-policy \
    --bucket $BUCKET_NAME \
    --policy file://bucket-policy.json

echo "Bucket policy applied for public read access"

# Verify bucket policy
aws s3api get-bucket-policy --bucket $BUCKET_NAME
```

#### Step 8: Test Static Website
```bash
# Test website accessibility
echo "Testing website endpoint:"
curl -s http://$WEBSITE_ENDPOINT | head -5

# Test specific object access
echo "Testing direct object access:"
curl -s "https://$BUCKET_NAME.s3.us-east-1.amazonaws.com/welcome.txt"

# List all objects with storage classes
echo "Objects and their storage classes:"
aws s3api list-objects-v2 \
    --bucket $BUCKET_NAME \
    --query 'Contents[].[Key, StorageClass]' \
    --output table
```

#### Step 9: Test Versioning
```bash
# Upload a new version of welcome.txt
cat > welcome-v2.txt << 'EOF'
Welcome to AWS S3 Interview Preparation!
This is VERSION 2 of the welcome file.
Uploaded on: $(date)
EOF

aws s3 cp welcome-v2.txt s3://$BUCKET_NAME/welcome.txt

# Check versions again
echo "Object versions after update:"
aws s3api list-object-versions --bucket $BUCKET_NAME --query 'Versions[].[Key, VersionId, IsLatest, LastModified]' --output table

# Download specific version
echo "Downloading original version:"
ORIGINAL_VERSION_ID=$(aws s3api list-object-versions --bucket $BUCKET_NAME --query 'Versions[?IsLatest==`false`].[VersionId]' --output text)
aws s3api get-object --bucket $BUCKET_NAME --key welcome.txt --version-id $ORIGINAL_VERSION_ID welcome-original.txt
cat welcome-original.txt
```

### Part 2: Cleanup

#### Step 10: Clean Up Resources
```bash
# NOTE: In a real scenario, you might want to keep some resources for review
# Uncomment the following lines when ready to clean up

# Delete all object versions (required before deleting bucket with versioning)
echo "Deleting all object versions..."
aws s3api list-object-versions --bucket $BUCKET_NAME --output=json |
    jq -r '.Versions[].Key + " " + .Versions[].VersionId' |
    while read key version; do
        if [[ -n "$key" && -n "$version" ]]; then
            aws s3api delete-object --bucket $BUCKET_NAME --key "$key" --version-id "$version"
        fi
    done

# Delete delete markers
echo "Deleting delete markers..."
aws s3api list-object-versions --bucket $BUCKET_NAME --output=json |
    jq -r '.DeleteMarkers[].Key + " " + .DeleteMarkers[].VersionId' |
    while read key version; do
        if [[ -n "$key" && -n "$version" ]]; then
            aws s3api delete-object --bucket $BUCKET_NAME --key "$key" --version-id "$version"
        fi
    done

# Delete bucket policy
aws s3api delete-bucket-policy --bucket $BUCKET_NAME

# Delete website configuration
aws s3api delete-bucket-website --bucket $BUCKET_NAME

# Delete lifecycle configuration
aws s3api delete-bucket-lifecycle --bucket $BUCKET_NAME

# Finally, delete the bucket
echo "Deleting bucket: $BUCKET_NAME"
aws s3api delete-bucket --bucket $BUCKET_NAME

echo "Cleanup complete! All S3 resources removed."
```

## Verification Checklist
- [ ] Unique S3 bucket created successfully
- [ ] Versioning enabled and verified
- [ ] Sample files uploaded (welcome.txt, index.html, data.json)
- [ ] Lifecycle policy configured (transition to Glacier after 30 days)
- [ ] Static website hosting enabled with index/error documents
- [ ] Bucket policy configured for public read access
- [ ] Website accessible via endpoint
- [ ] Error page functioning correctly
- [ ] Versioning tested (upload new version, verify both versions exist)
- [ ] Original version retrievable via version ID
- [ ] Objects show correct storage classes

## Troubleshooting Tips

### Bucket Creation Issues
- **Bucket name already exists**: S3 bucket names must be globally unique - use timestamp or random suffix
- **Invalid bucket name**: Follow S3 naming conventions (3-63 chars, lowercase, numbers, hyphens, periods)
- **Region mismatch**: Ensure CreateBucketConfiguration matches your target region (not needed for us-east-1)

### Versioning Issues
- **Cannot enable versioning**: Ensure you have s3:PutBucketVersioning permission
- **Versioning not showing**: Use `list-object-versions` not `list-objects` to see versions
- **Delete markers appearing**: Normal when deleting objects in versioned buckets

### Website Hosting Issues
- **403 Forbidden**: Missing bucket policy for public read access or Block Public Access enabled
- **404 Not Found**: Wrong index document name or file not uploaded
- **Website endpoint not resolving**: Wait a few minutes for DNS propagation or check website configuration

### Lifecycle Policy Issues
- **Policy not applying**: Check JSON syntax and ensure proper format
- **Transitions not working**: Verify object size (must be > 128KB for IA/Glacier transition)
- **Expiration not occurring**: Check that current time + days exceeds object's last modified date

### Access Issues
- **Access Denied**: Check IAM permissions, bucket policy, and ACLs
- **Slow Performance**: Consider S3 Transfer Acceleration for distant users
- **Unexpected Charges**: Review storage class usage and data transfer reports

## Learning Outcomes
By completing this exercise, you will have:
1. Created and configured S3 buckets with proper naming conventions
2. Enabled and tested versioning for data protection
3. Applied lifecycle policies for cost optimization
4. Configured static website hosting with custom error pages
5. Set bucket policies for controlled public access
6. Worked with multiple storage classes and verified transitions
7. Practiced object version management and recovery
8. Gained experience with AWS CLI for S3 operations

## Next Steps
- Experiment with different storage classes (Standard-IA, One Zone-IA, Intelligent-Tiering)
- Try setting up cross-region replication between two buckets
- Explore S3 Select for querying object content without downloading
- Work with S3 Batch Operations for large-scale object modifications
- Practice with S3 Access Points for simplified access management
- Investigate S3 Object Lock for compliance and WORM storage requirements

## Resources Used
- Bucket Name: aws-interview-s3-[TIMESTAMP] (globally unique)
- Region: us-east-1
- Storage Classes: Standard (default), Glacier (via lifecycle)
- Website Endpoint: bucket-name.s3-website-us-east-1.amazonaws.com