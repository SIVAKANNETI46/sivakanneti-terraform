output publicip {
  value       = aws_instance.instance.private_ip
  description = "description"
}

output subnetid {
  value       = aws_instance.instance.subnet_id
  description = "description"
}

output userdata {
  value       = aws_instance.instance.user_data
  description = "description"
}


output securitygroup {
  value       = aws_instance.instance.security_groups
  description = "description"
}


output loadbalancer_instance {
  value       = aws_elb.loadbalancer.instances
  description = "description"

}

output loadbalancer_dns {
  value       = aws_elb.loadbalancer.dns_name
  description = "description"

}
