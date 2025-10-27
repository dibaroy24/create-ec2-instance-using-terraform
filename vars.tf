variable location {
    description = "The location where resources are created"
    default     = "us-east-1"
}

variable vpc_cidr_block {
    description = "The CIDR block reserved for the VPC"
    default     = "10.0.0.0/16"
}

variable subnet_cidr_block_1 {
    description = "The CIDR block reserved for the subnet-1"
    default     = "10.0.1.0/24"
}

variable subnet_cidr_block_2 {
    description = "The CIDR block reserved for the subnet-2"
    default     = "10.0.2.0/24"
}

# variable avail_zone {}
variable env_prefix {
    description = "The value of the prefix will be used in naming of all resources in this exercise"
    default = "dev20251019"
}

variable instance_type {
    description = "The size of the instance"
    default = "t2.medium"
}

variable ingress_port_1 {
    description = "The additional ingress port #1 the instance apart from SSH port"
    type = number
    default = 80
}

variable ingress_port_2 {
    description = "The additional ingress port #2 the instance apart from SSH port"
    type = number
    default = 8000
}

variable public_key_location {
    description = "Path to the public key file for the EC2 key pair"
    type        = string
    default     = "~/.ssh/my_tfkey.pub" # Example default path
}
