# Reasoning

## Cost Reduction

### NAT Gateway Strategy

For cost reduction, this configures `nat_gateway_mode` with two options:

- `single`: deploys one NAT Gateway in the first public subnet and routes both private subnets through it
- `per_az`: deploys one NAT Gateway per Availability Zone so each private subnet uses same-AZ egress

The default is `single` as it  lowers the AWS bill while still preserving Multi-AZ application deployment.


### other choices

- Use of  ECS on Fargate instead of EC2  to avoid EC2 capacity planning, idle instances waiting for traffic and maintaining AMI.
- CloudWatch log retention is capped with `log_retention_in_days` instead of retaining logs forever.


## Disaster Recovery

### If an Entire AWS Region went offline

code is parameterized in  `aws_region`, so recovery to another AWS Region is easy task. we just need to choose a secondary AWS region,  and terraform apply for infra provisioning. We may need to build an image and push it to ecr of that region too if image replication is not set before. ( Note: this doesnot covers db) 


## Observability

### Current Implementation
- CloudWatch Logs to store logs
- ECS Container Insights on the ECS cluster

Alerting can be added on conditions like these if required:
- ECS CPU and memory high usage
- deployment failures and restarts
- route53 health checks
