// Creation of AWS VPC

resource "aws_vpc" "my_vpc" {
    cidr_block = var.cidrblock
    tags = {
        Name = "New_VPC"
    }
}

//Creation of public and private subnets

resource "aws_subnet" "new_public_subnet1" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = var.publiccidr1
    availability_zone = var.availabilityzone1
    tags = {
        Name = "Public_Subnet_1"
    }
}

resource "aws_subnet" "new_public_subnet2" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = var.publiccidr2
    availability_zone = var.availabilityzone2
    tags = {
        Name = "Public_Subnet_2"
    }
}

resource "aws_subnet" "new_private_subnet1" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = var.privatecidr1
    availability_zone = var.availabilityzone1
    tags = {
        Name = "Private_Subnet_1"
    }
}

resource "aws_subnet" "new_private_subnet2" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = var.privatecidr2
    availability_zone = var.availabilityzone2
    tags = {
        Name = "Private_Subnet_2"
    }
}

// Creation of Internet Gateway

resource "aws_internet_gateway" "myIGW" {
    vpc_id = aws_vpc.my_vpc.id
    tags = {
        Name = "myIGW"
    }
}

//Creation of Route table

resource "aws_route_table" "myroutetable" {
    vpc_id = aws_vpc.my_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.myIGW.id
    }
    tags = {
        Name = "My_Route_table"
    }
}

//Associate Subnets to route table

resource "aws_route_table_association" "mypublicassociation1" {
    subnet_id = aws_subnet.new_public_subnet1.id
    route_table_id = aws_route_table.myroutetable.id
}

resource "aws_route_table_association" "mypublicassociation2" {
    subnet_id = aws_subnet.new_public_subnet2.id
    route_table_id = aws_route_table.myroutetable.id
}

//Creation of Security group

resource "aws_security_group" "new_sg1" {
    name = "new_sg1"
    description = "This is the new security group"
    vpc_id = aws_vpc.my_vpc.id
    tags = {
        Name = "new_sg1"
    }
}

resource "aws_vpc_security_group_ingress_rule" "new_sg1_ingress1" {
    security_group_id = aws_security_group.new_sg1.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 22
    to_port = 22
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "new_sg1_ingress2" {
    security_group_id = aws_security_group.new_sg1.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 80
    to_port = 80
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "new_sg1_ingress3" {
    security_group_id = aws_security_group.new_sg1.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 443
    to_port = 443
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "new_sg1_egress1" {
  security_group_id = aws_security_group.new_sg1.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

//Creating AWS instance in public subnet

resource "aws_instance" "new_instance1" {
    ami = var.ami_id
    instance_type = var.inatance_type
    security_groups = [aws_security_group.new_sg1.id]
    subnet_id = aws_subnet.new_public_subnet1.id
    key_name = var.keyname
    associate_public_ip_address = true
    tags = {
        Name = "New_Public_Instance"
    }
}

//Installing HTTPD, PHP, DB connector, Git to the EC2 instance

resource "null_resource" "nullresource1" {
    provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd -y",
      "sudo yum install git -y",
      "sudo yum install mariadb105 php8.2 -y",
      "sudo yum install php-mysqli -y",
      "sudo git clone https://github.com/WordPress/WordPress.git",
      "sudo mv WordPress/* /var/www/html/",
      "sudo chown apache -R /var/www/html",
      "sudo systemctl restart httpd"
    ]
    connection {
        type = "ssh"
        user = "ec2-user"
        private_key = file("G:/terraform projects/new_key.pem")
        host = aws_instance.new_instance1.public_ip
    }
}
}

resource "null_resource" "nullresource2" {
    provisioner "local-exec" {
        command = "start http://${aws_instance.new_instance1.public_ip}:80"
    }
    depends_on = [
        null_resource.nullresource1
    ]
}


// Creation of Security group and Ingress & Egress rules

resource "aws_security_group" "db_security_group" {
    name = "db_security_group"
    vpc_id = aws_vpc.my_vpc.id
    tags = {
        Name = "DB_Security_group"
    }
}

resource "aws_vpc_security_group_ingress_rule" "db_ingress1" {
    security_group_id = aws_security_group.db_security_group.id
    cidr_ipv4 = var.publiccidr1
    from_port = "3306"
    to_port = "3306"
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "db_ingress2" {
    security_group_id = aws_security_group.db_security_group.id
    cidr_ipv4 = var.publiccidr2
    from_port = "3306"
    to_port = "3306"
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "db_egress" {
  security_group_id = aws_security_group.db_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

// Creation of subnet group for DB instance

resource "aws_db_subnet_group" "new_group" {
    name = "new_group"
    subnet_ids = [aws_subnet.new_private_subnet1.id, aws_subnet.new_private_subnet2.id]
    tags = {
        Name = "New Subnet Group"
    }
}

//Creation of RDS Instance

resource "aws_db_instance" "my_db" {
    allocated_storage = var.db_storage
    db_name = "my_db"
    engine = "mysql"
    engine_version = var.db_engine_version
    instance_class = var.db_instance_class
    username = "admin"
    password = "Password"
    parameter_group_name = var.parameter_group
    db_subnet_group_name = aws_db_subnet_group.new_group.id
    vpc_security_group_ids = [aws_security_group.db_security_group.id]
}
