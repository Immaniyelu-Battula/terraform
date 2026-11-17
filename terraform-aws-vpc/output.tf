output "vpc_id" {
  value = aws_vpc.main.id
}

output "availability_zone" {
  value = slice(data.aws_availability_zones.available.names,0,2)
}

