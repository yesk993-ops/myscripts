AWS Cost CHeck script

#!/bin/bash
# AWS resource cost check script (extended with networking items)

echo "=== EC2 Instances (running) ==="
aws ec2 describe-instances \
  --query 'Reservations[].Instances[?State.Name==`running`].[InstanceId,InstanceType,State.Name,Tags]' \
  --output table

echo "=== EBS Volumes (in-use) ==="
aws ec2 describe-volumes \
  --query 'Volumes[?State==`in-use`].[VolumeId,Size,VolumeType,Attachments[].InstanceId]' \
  --output table

echo "=== RDS Instances ==="
aws rds describe-db-instances \
  --query 'DBInstances[].{DBInstanceIdentifier:DBInstanceIdentifier,Engine:Engine,Status:DBInstanceStatus}' \
  --output table

echo "=== S3 Buckets ==="
aws s3 ls

echo "=== Lambda Functions ==="
aws lambda list-functions \
  --query 'Functions[].FunctionName' \
  --output table

echo "=== Elastic IPs (not attached) ==="
aws ec2 describe-addresses \
  --query 'Addresses[?AssociationId==null].[PublicIp]' \
  --output table

echo "=== Classic Load Balancers ==="
aws elb describe-load-balancers \
  --query 'LoadBalancerDescriptions[].LoadBalancerName' \
  --output table

echo "=== Application/Network Load Balancers ==="
aws elbv2 describe-load-balancers \
  --query 'LoadBalancers[].{Name:LoadBalancerName,Type:Type,State:State.Code}' \
  --output table

echo "=== NAT Gateways ==="
aws ec2 describe-nat-gateways \
  --query 'NatGateways[].{NatGatewayId:NatGatewayId,State:State,SubnetId:SubnetId}' \
  --output table

echo "=== VPC Endpoints ==="
aws ec2 describe-vpc-endpoints \
  --query 'VpcEndpoints[].{VpcEndpointId:VpcEndpointId,ServiceName:ServiceName,State:State}' \
  --output table

echo "=== Transit Gateways ==="
aws ec2 describe-transit-gateways \
  --query 'TransitGateways[].{TransitGatewayId:TransitGatewayId,State:State}' \
  --output table

echo "=== VPN Connections ==="
aws ec2 describe-vpn-connections \
  --query 'VpnConnections[].{VpnConnectionId:VpnConnectionId,State:State}' \
  --output table

echo "=== Done. Review above resources. ==="
