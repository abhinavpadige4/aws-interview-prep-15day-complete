#!/bin/bash
# AWS EC2 Launch Script for Interview Preparation
# This script automates the creation of a t2.micro EC2 instance with Apache web server

set -euo pipefail

# Configuration
KEY_NAME="aws-interview-key"
SG_NAME="aws-interview-sg"
INSTANCE_TYPE="t2.micro"
REGION="us-east-1"
AMI_NAME="amzn2-ami-hvm-*-x86_64-gp2"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting EC2 instance setup for AWS interview preparation...${NC}"

# Get public IP for SSH restriction
MY_IP=$(curl -s http://checkip.amazonaws.com)/32
echo -e "${YELLOW}Your public IP: $MY_IP${NC}"

# Find latest Amazon Linux 2 AMI
echo -e "${YELLOW}Finding latest Amazon Linux 2 AMI...${NC}"
AMI_ID=$(aws ec2 describe-images \
    --owners amazon \
    --filters "Name=name,Values=$AMI_NAME" "Name=state,Values=available" \
    --query 'Images[0].ImageId' --output text --region $REGION)

if [[ -z "$AMI_ID" || "$AMI_ID" == "None" ]]; then
    echo -e "${RED}Error: Could not find Amazon Linux 2 AMI${NC}"
    exit 1
fi
echo -e "${GREEN}Found AMI: $AMI_ID${NC}"

# Get default VPC
echo -e "${YELLOW}Getting default VPC...${NC}"
VPC_ID=$(aws ec2 describe-vpcs \
    --filters "Name=isDefault,Values=true" \
    --query 'Vpcs[0].VpcId' --output text --region $REGION)

if [[ -z "$VPC_ID" || "$VPC_ID" == "None" ]]; then
    echo -e "${RED}Error: Could not find default VPC${NC}"
    exit 1
fi
echo -e "${GREEN}Found VPC: $VPC_ID${NC}"

# Create key pair if it doesn't exist
echo -e "${YELLOW}Setting up SSH key pair...${NC}"
if ! aws ec2 describe-key-pairs --key-names "$KEY_NAME" --region $REGION >/dev/null 2>&1; then
    echo -e "${YELLOW}Creating new key pair: $KEY_NAME${NC}"
    aws ec2 create-key-pair \
        --key-name "$KEY_NAME" \
        --query 'KeyMaterial' \
        --output text \
        --region $REGION > "$KEY_NAME.pem"
    chmod 400 "$KEY_NAME.pem"
    echo -e "${GREEN}Key pair created and saved as $KEY_NAME.pem${NC}"
else
    echo -e "${GREEN}Key pair $KEY_NAME already exists${NC}"
fi

# Create security group
echo -e "${YELLOW}Setting up security group...${NC}"
if ! aws ec2 describe-security-groups --group-names "$SG_NAME" --region $REGION >/dev/null 2>&1; then
    echo -e "${YELLOW}Creating security group: $SG_NAME${NC}"
    SG_ID=$(aws ec2 create-security-group \
        --group-name "$SG_NAME" \
        --description "Security group for AWS interview prep" \
        --vpc-id "$VPC_ID" \
        --query 'GroupId' --output text --region $REGION)
    
    # Add SSH rule (restricted to your IP)
    aws ec2 authorize-security-group-ingress \
        --group-id "$SG_ID" \
        --protocol tcp \
        --port 22 \
        --cidr "$MY_IP" \
        --region $REGION
    
    # Add HTTP rule
    aws ec2 authorize-security-group-ingress \
        --group-id "$SG_ID" \
        --protocol tcp \
        --port 80 \
        --cidr 0.0.0.0/0 \
        --region $REGION
    
    # Add HTTPS rule
    aws ec2 authorize-security-group-ingress \
        --group-id "$SG_ID" \
        --protocol tcp \
        --port 443 \
        --cidr 0.0.0.0/0 \
        --region $REGION
    
    echo -e "${GREEN}Security group created: $SG_ID${NC}"
else
    SG_ID=$(aws ec2 describe-security-groups \
        --group-names "$SG_NAME" \
        --query 'SecurityGroups[0].GroupId' --output text --region $REGION)
    echo -e "${GREEN}Security group $SG_NAME already exists: $SG_ID${NC}"
fi

# Launch EC2 instance
echo -e "${YELLOW}Launching $INSTANCE_TYPE instance...${NC}"
INSTANCE_ID=$(aws ec2 run-instances \
    --image-id "$AMI_ID" \
    --instance-type "$INSTANCE_TYPE" \
    --key-name "$KEY_NAME" \
    --security-group-ids "$SG_ID" \
    --query 'Instances[0].InstanceId' --output text --region $REGION)

echo -e "${GREEN}Launched instance: $INSTANCE_ID${NC}"

# Wait for instance to be running
echo -e "${YELLOW}Waiting for instance to be running...${NC}"
aws ec2 wait instance-running --instance-ids "$INSTANCE_ID" --region $REGION

# Get instance details
echo -e "${YELLOW}Getting instance details...${NC}"
INSTANCE_INFO=$(aws ec2 describe-instances \
    --instance-ids "$INSTANCE_ID" \
    --region $REGION)

PUBLIC_IP=$(echo "$INSTANCE_INFO" | jq -r '.Reservations[0].Instances[0].PublicIpAddress')
PUBLIC_DNS=$(echo "$INSTANCE_INFO" | jq -r '.Reservations[0].Instances[0].PublicDnsName')

if [[ -z "$PUBLIC_IP" || "$PUBLIC_IP" == "null" ]]; then
    echo -e "${RED}Error: Could not get public IP for instance${NC}"
    exit 1
fi

echo -e "${GREEN}Instance is running!${NC}"
echo -e "${GREEN}Public IP: $PUBLIC_IP${NC}"
echo -e "${GREEN}Public DNS: $PUBLIC_DNS${NC}"

# Provide connection instructions
echo -e "\n${GREEN}=== CONNECTION INSTRUCTIONS ===${NC}"
echo -e "To connect to your instance:"
echo -e "ssh -i \"$KEY_NAME.pem\" ec2-user@$PUBLIC_DNS"
echo -e ""
echo -e "To test the web server once Apache is installed:"
echo -e "curl http://$PUBLIC_IP"
echo -e "Or visit in browser: http://$PUBLIC_IP"
echo -e ""

# Provide cleanup instructions
echo -e "${YELLOW}=== CLEANUP INSTRUCTIONS ===${NC}"
echo -e "To avoid charges, remember to terminate resources when done:"
echo -e "aws ec2 terminate-instances --instance-ids $INSTANCE_ID --region $REGION"
echo -e "aws ec2 wait instance-terminated --instance-ids $INSTANCE_ID --region $REGION"
echo -e "aws ec2 delete-security-group --group-id $SG_ID --region $REGION"
echo -e "aws ec2 delete-key-pair --key-name $KEY_NAME --region $REGION"
echo -e "rm -f $KEY_NAME.pem"
echo -e ""

# Save instance info for later use
cat > instance-info.txt << EOF
INSTANCE_ID=$INSTANCE_ID
PUBLIC_IP=$PUBLIC_IP
PUBLIC_DNS=$PUBLIC_DNS
KEY_NAME=$KEY_NAME
SG_ID=$SG_ID
REGION=$REGION
LAUNCH_TIME=$(date)
EOF

echo -e "${YELLOW}Instance information saved to instance-info.txt${NC}"
echo -e "${GREEN}Setup complete! Your EC2 instance is ready for configuration.${NC}"