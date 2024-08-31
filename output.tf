output "vpc_id" {
    value =  aws_vpc.my_vpc.id
}

output "public_subnet1" {
    value = aws_subnet.new_public_subnet1.id
}

output "public_subnet2" {
    value = aws_subnet.new_public_subnet2.id
}

output "private_subnet1" {
    value = aws_subnet.new_private_subnet1.id
}

output "private_subnet2" {
    value = aws_subnet.new_private_subnet2.id
}

output "internetgateway" {
    value = aws_internet_gateway.myIGW.id
}

output "Route_Table" {
    value = aws_route_table.myroutetable.id
}

output "Security_group_ID1" {
    value = aws_security_group.new_sg1.id
}

output "EC2_ID" {
    value = aws_instance.new_instance1.id
}

output "DB_ID" {
    value = aws_db_instance.my_db.id
}