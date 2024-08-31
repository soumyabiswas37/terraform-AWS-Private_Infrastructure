variable "AWS_Region" {
    default = "us-east-1"
}

variable "cidrblock" {
    default = "10.1.0.0/16"
}

variable "availabilityzone1" {
    default = "us-east-1a"
}

variable "availabilityzone2" {
    default = "us-east-1b"
}

variable "publiccidr1" {
    default = "10.1.1.0/24"
}

variable "publiccidr2" {
    default = "10.1.2.0/24"
}

variable "privatecidr1" {
    default = "10.1.3.0/24"
}

variable "privatecidr2" {
    default = "10.1.4.0/24"
}

variable "ami_id" {
    default = "ami-0ae8f15ae66fe8cda"
}

variable "inatance_type" {
    default = "t2.micro"
}

variable "keyname" {
    default = "new_key"
}

variable "db_password" {
    default = "P@ssw0rd"
}

variable "db_storage" {
    default = "10"
}

variable "db_engine_version" {
    default = "8.0.35"
}

variable "db_instance_class" {
    default = "db.t3.micro"
}

variable "parameter_group" {
    default = "default.mysql8.0"
}