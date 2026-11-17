variable "vpc_cidr_block" {
    type=string  
    default = "10.0.0.0/16" #Optional vars
}

variable "project" {   #Mandatory vars
  type=string 
}     

variable "environment" {   #Mandatory vars
  type=string 
} 

variable "vpc_tags" {
    type = map
    default = {} #Optional vars
}

variable "igw_tags" {
    type = map
    default = {} #Optional vars
}


variable "public_subnet_cidrs" {
    type = list
    default = ["10.0.1.0/24","10.0.2.0/24"] #Optional vars
}

variable "private_subnet_cidrs" {
    type = list
    default = ["10.0.11.0/24","10.0.12.0/24"] #Optional vars
}

variable "database_subnet_cidrs" {
    type = list
    default = ["10.0.21.0/24","10.0.22.0/24"] #Optional vars
}

variable "public_subnet_tags" {
    type = map
    default = {} #Optional vars
}

variable "private_subnet_tags" {
    type = map
    default = {} #Optional vars
}

variable "database_subnet_tags" {
    type = map
    default = {} #Optional vars
}

variable "common_name" {
    type = map
    default = {} #Optional vars
}


variable "public_rt_tags" {
    type = map
    default = {} #Optional vars
} 


variable "private_rt_tags" {
    type = map
    default = {} #Optional vars
} 

variable "database_rt_tags" {
    type = map
    default = {} #Optional vars
} 