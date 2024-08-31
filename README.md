# Multitier application setup on AWS
The infrastructure is setup within a personal VPC (not default VPC), configured with public and private subnets which are required to setup the frontend and backend of the application respectively, internet gateway and route table to direct the network traffic. 
Frontend is configured on an EC2 instance which is accessible publicly 
Backend is configured on MySQL DB which is not accessible publicly.
