# Day 1: EC2 Hands-on Exercise

## Objective
Launch a t2.micro EC2 instance, configure security group, connect via SSH, install Apache, and create a simple HTML page.

## Prerequisites
- AWS Free Tier account
- AWS CLI installed and configured
- SSH client (built-in on Linux/Mac, PuTTY on Windows)
- Text editor

## Estimated Time: 60 minutes

## Step-by-Step Instructions

### Part 1: Preparation

#### Step 1: Create a Key Pair
```bash
# Create directory for AWS exercises
mkdir -p ~/aws-exercises/ec2
cd ~/aws-exercises/ec2

# Create key pair
aws ec2 create-key-pair --key-name aws-interview-key --query 'KeyMaterial' --output text > aws-interview-key.pem

# Set proper permissions (Linux/Mac)
chmod 400 aws-interview-key.pem

# Verify key pair was created
aws ec2 describe-key-pairs --key-names aws-interview-key
```

#### Step 2: Create Security Group
```bash
# Get your VPC ID (default VPC)
VPC_ID=$(aws ec2 describe-vpcs --filters "Name=isDefault,Values=true" --query 'Vpcs[0].VpcId' --output text)

# Create security group
SECURITY_GROUP_ID=$(aws ec2 create-security-group \
    --group-name aws-interview-sg \
    --description "Security group for AWS interview prep EC2 instance" \
    --vpc-id $VPC_ID \
    --query 'GroupId' --output text)

echo "Security Group ID: $SECURITY_GROUP_ID"

# Add inbound rules
# SSH access (port 22) - restrict to your IP for security
MY_IP=$(curl -s http://checkip.amazonaws.com)
aws ec2 authorize-security-group-ingress \
    --group-id $SECURITY_GROUP_ID \
    --protocol tcp \
    --port 22 \
    --cidr $MY_IP/32

# HTTP access (port 80) - for Apache web server
aws ec2 authorize-security-group-ingress \
    --group-id $SECURITY_GROUP_ID \
    --protocol tcp \
    --port 80 \
    --cidr 0.0.0.0/0

# HTTPS access (port 443) - optional
aws ec2 authorize-security-group-ingress \
    --group-id $SECURITY_GROUP_ID \
    --protocol tcp \
    --port 443 \
    --cidr 0.0.0.0/0
```

### Part 2: Launch EC2 Instance

#### Step 3: Find Amazon Linux 2 AMI
```bash
# Find latest Amazon Linux 2 AMI in your region
AMI_ID=$(aws ec2 describe-images \
    --owners amazon \
    --filters "Name=name,Values=amzn2-ami-hvm-*-x86_64-gp2" "Name=state,Values=available" \
    --query 'Images[0].ImageId' --output text --region us-east-1)

echo "Using AMI ID: $AMI_ID"
```

#### Step 4: Launch the EC2 Instance
```bash
# Launch t2.micro instance
INSTANCE_ID=$(aws ec2 run-instances \
    --image-id $AMI_ID \
    --count 1 \
    --instance-type t2.micro \
    --key-name aws-interview-key \
    --security-group-ids $SECURITY_GROUP_ID \
    --query 'Instances[0].InstanceId' --output text)

echo "Launched instance ID: $INSTANCE_ID"

# Wait for instance to be running
aws ec2 wait instance-running --instance-ids $INSTANCE_ID

# Get instance details
INSTANCE_INFO=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID)
PUBLIC_IP=$(echo $INSTANCE_INFO | jq -r '.Reservations[0].Instances[0].PublicIpAddress')
PUBLIC_DNS=$(echo $INSTANCE_INFO | jq -r '.Reservations[0].Instances[0].PublicDnsName')

echo "Public IP: $PUBLIC_IP"
echo "Public DNS: $PUBLIC_DNS"
```

### Part 3: Connect and Configure

#### Step 5: Connect via SSH
```bash
# Connect to the instance
ssh -i "aws-interview-key.pem" ec2-user@$PUBLIC_DNS

# Once connected, you should see:
#       __|  __|_  )
#       _|  (     /   Amazon Linux 2
#      ___|\___|___|

# Update the system
sudo yum update -y

# Install Apache web server
sudo yum install -y httpd

# Start and enable Apache service
sudo systemctl start httpd
sudo systemctl enable httpd

# Verify Apache is running
sudo systemctl status httpd
```

#### Step 6: Create Simple HTML Page
```bash
# Navigate to web root directory
cd /var/www/html

# Create a simple HTML file
cat > index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AWS Interview Prep - EC2 Demo</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h1 {
            color: #ff9900;
            text-align: center;
        }
        .highlight {
            background-color: #fff8dc;
            padding: 15px;
            border-left: 4pxff9900;
            margin: 20px 0;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>AWS Cloud Engineer Interview Prep</h1>
        <p>Successfully launched and configured an EC2 instance!</p>
        
        <div class="highlight">
            <h2>Instance Details:</h2>
            <ul>
                <li><strong>Instance Type:</strong> t2.micro</li>
                <li><strong>AMI:</strong> Amazon Linux 2</li>
                <li><strong>Region:</strong> us-east-1</li>
                <li><strong>Public IP:</strong> ''' + $PUBLIC_IP + '''</li>
                <li><strong>Security Group:</strong> aws-interview-sg</li>
            </ul>
        </div>
        
        <div class="highlight">
            <h2>What We Accomplished:</h2>
            <ul>
                <li>Launched EC2 instance using AWS CLI</li>
                <li>Configured security group for SSH and HTTP access</li>
                <li>Connected via SSH using key pair</li>
                <li>Installed and configured Apache web server</li>
                <li>Created custom HTML landing page</li>
            </ul>
        </div>
        
        <p><em>Next steps: Try accessing http://''' + $PUBLIC_IP + ''' from your browser!</em></p>
    </div>
</body>
</html>
EOF

# Set proper permissions
sudo chmod 644 /var/www/html/index.html

# Exit SSH session
exit
```

#### Step 7: Test the Web Server
```bash
# From your local machine, test the web server
curl http://$PUBLIC_IP

# You should see the HTML content we just created
# Alternatively, open in browser: http://$PUBLIC_IP
```

### Part 4: Cleanup (Important for Free Tier)

#### Step 8: Terminate Resources
```bash
# Terminate the EC2 instance
aws ec2 terminate-instances --instance-ids $INSTANCE_ID
echo "Terminating instance $INSTANCE_ID"

# Wait for termination
aws ec2 wait instance-terminated --instance-ids $INSTANCE_ID

# Delete the security group
aws ec2 delete-security-group --group-id $SECURITY_GROUP_ID
echo "Deleted security group $SECURITY_GROUP_ID"

# Delete the key pair
aws ec2 delete-key-pair --key-name aws-interview-key
rm aws-interview-key.pem
echo "Deleted key pair and local key file"

echo "Cleanup complete! All resources terminated."
```

## Verification Checklist
- [ ] Key pair created with proper permissions (400)
- [ ] Security group created with SSH (22) and HTTP (80) rules
- [ ] t2.micro instance launched successfully
- [ ] Instance reached running state
- [ ] Connected via SSH using key pair
- [ ] Apache web server installed and running
- [ ] Custom HTML page created and accessible
- [ ] Resources properly cleaned up to avoid charges

## Troubleshooting Tips

### Connection Issues
- **Timeout connecting via SSH**: Check security group inbound rule for port 22
- **Permission denied (publickey)**: Verify key pair permissions (400) and correct key file
- **Host key verification failed**: Remove old entry from `~/.ssh/known_hosts`

### Apache Issues
- **Service not starting**: Check `sudo journalctl -u httpd` for error logs
- **Port already in use**: Ensure no other service is running on port 80
- **Page not loading**: Verify security group allows inbound HTTP (port 80)

### AWS CLI Issues
- **Command not found**: Install AWS CLI: `curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"`
- **Authentication failed**: Run `aws configure` to set up credentials
- **Invalid region**: Specify region with `--region us-east-1` or set default region

## Learning Outcomes
By completing this exercise, you will have:
1. Practiced EC2 instance lifecycle management
2. Configured security groups and network access
3. Used key pairs for secure SSH access
4. Installed and configured web server software
5. Created and deployed web content
6. Properly cleaned up resources to avoid charges
7. Gained hands-on experience with AWS CLI

## Next Steps
- Try different instance types (t3.micro, t3.small)
- Experiment with Elastic IP assignment
- Create AMI from your configured instance
- Explore EC2 Auto Scaling basics
- Practice with Windows EC2 instances (different authentication method)

## Resources Used
- Amazon Linux 2 AMI: amzn2-ami-hvm-*-x86_64-gp2
- Instance Type: t2.micro (Free Tier eligible)
- Region: us-east-1 (adjust as needed)
- Security Group: Custom rules for SSH and HTTP