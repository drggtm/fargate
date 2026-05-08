# AWS ECS Fargate Production-Style Terraform

This project uses Terraform to provision  AWS infra for web application and includes a CI/CD workflow for building, pushing, and deploying a Docker image.


## What It Provisions

- `1` VPC with `2` public subnets and `2` private subnets across `2` Availability Zones
- Internet Gateway and configurable NAT Gateway strategy:
  - `single`
  - `per_az`
- Internet-facing Application Load Balancer in  public_subnets
- ECS cluster running an ECS Fargate service in  private_subnets
- Application Auto Scaling for  ECS services
- ECR repository for CI/CD image pushes
- CloudWatch log group for container logs
- Secrets Manager secret for application secret injection


## Requirement Mapping

### Infrastructure as Code

- VPC, subnets, routing, NAT, security groups, ALB, ECS, ECR, Secrets Manager, IAM, GitHub OIDC deployment role, and autoscaling are defined in [main.tf](main.tf).
- Input tuning lives in [variables.tf](variables.tf).
- Useful outputs live in [outputs.tf](outputs.tf).

### Networking and Fault Tolerance

- `2` public subnets host  ALB and NAT Gateway resources.
- `2` private subnets host  ECS tasks and can also serve as private application or database subnets.
- ECS tasks are deployed into both private subnets, which span at least two AZs.

### Secret Management and Security

- A Secrets Manager secret is created and injected into the container as `APP_SECRET_JSON`.
- No hardcoded credentials are stored in Terraform.
- Because this stack uses Fargate, IAM task roles and execution roles are used in place of an EC2 instance profile.
- The ECS execution role is restricted to:
  - reading only the specific application secret
  - writing only to the specific CloudWatch log group
  - pulling from only the provisioned ECR repository, plus the required ECR auth token action

### Compute

- Uses ECS Fargate rather than an EC2 Auto Scaling Group.
- ECS service runs a simple web server and includes CPU-based application autoscaling.


## Terraform Usage

```bash
cp terraform.tfvars.example terraform.tfvars
terraform init -backend=false
terraform validate
terraform plan
terraform apply
```


## Remote State to store state file

1. Bootstrap  S3 backend in [s3-backend/main.tf](s3-backend/main.tf).
2. Copy [backend.hcl.example](backend.hcl.example) to `backend.hcl` and fill in the bucket, region, and optional AWS profile.
3. Reinitialize root stack to migrate local state into S3.

Bootstrap example:

```bash
cd s3-backend
terraform init
terraform apply -var="aws_profile=your-aws-profile" -var="aws_region=us-east-1"
```

Then from  repo root:

```bash
cp backend.hcl.example backend.hcl
terraform init -reconfigure -backend-config=backend.hcl
```


## CI/CD

AGitHub Actions workflow is included at [.github/workflows/ci-cd.yml](.github/workflows/ci-cd.yml).

It does the following:

- validates Terraform
- builds and pushes a Docker image to ECR
- registers a new ECS task definition revision with  new image
- updates  ECS service to that new revision

To use it in GitHub after the initial Terraform apply, set these repository variables from Terraform outputs and your chosen region:

- `AWS_DEPLOY_ROLE_ARN`
- `AWS_REGION`
- `ECR_REPOSITORY`
- `ECS_CLUSTER`
- `ECS_SERVICE`
- `TASK_DEFINITION_FAMILY`

## Troubleshooting

Some common checks  includes:

- `terraform init -backend=false && terraform validate`
  Use this first if the root stack looks broken locally and you only want to verify configuration without touching remote state.
- `cd s3-backend && terraform init && terraform validate`
  Use this if backend bootstrapping or remote state setup is failing.
- Check GitHub Actions repository variables:
  `AWS_DEPLOY_ROLE_ARN`, `AWS_REGION`, `ECR_REPOSITORY`, `ECS_CLUSTER`, `ECS_SERVICE`, `TASK_DEFINITION_FAMILY`
- If CI builds succeed but deployment fails:
  confirm the GitHub OIDC role trust matches the repository set in `github_repo`
- If ECS deployment fails after image push:
  check  ECS service events, target group health, and CloudWatch log group `/ecs/<project_name>`
- If a human needs to recover the stack in another region:
  bootstrap state, re-apply Terraform with a new `aws_region`, make sure  image exists in ECR there, then repoint DNS



