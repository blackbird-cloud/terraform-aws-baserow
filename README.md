# AWS Baserow Terraform Module

Deploy a Baserow instance easily on AWS using Terraform. This module sets up the necessary infrastructure components including VPC, RDS, ElastiCache, and security groups.

## Setup

1. Ensure you have Terraform installed. You can download it from [terraform.io](https://www.terraform.io/downloads.html).
2. Configure your AWS credentials. You can do this by setting environment variables or using the AWS CLI.
3. Clone this repository to your local machine.
4. Navigate to the cloned directory and run `terraform init` to initialize the Terraform configuration.
5. Update the `terraform.tfvars` file with your desired configuration values.
6. Run `terraform apply` to create the infrastructure.

## Configuration

The module can be configured using the following variables:

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.13.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 3.0 |
| <a name="requirement_postgresql"></a> [postgresql](#requirement\_postgresql) | 1.26.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.13.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 3.0.2 |
| <a name="provider_postgresql"></a> [postgresql](#provider\_postgresql) | 1.26.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.client_vpn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.waf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_access_key.baserow_smtp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_user.baserow_smtp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user_policy.baserow_smtp_send](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy) | resource |
| [aws_kms_key.backup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key.rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key.valkey](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_route53_record.dkim](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.dmarc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_zone.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |
| [aws_security_group.client_vpn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.db](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.valkey](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_sesv2_configuration_set.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sesv2_configuration_set) | resource |
| [aws_sesv2_configuration_set_event_destination.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sesv2_configuration_set_event_destination) | resource |
| [aws_sesv2_email_identity.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sesv2_email_identity) | resource |
| [aws_sesv2_email_identity_policy.smtp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sesv2_email_identity_policy) | resource |
| [helm_release.baserow](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.metrics_server](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.opentelemetry](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [postgresql_database.baserow](https://registry.terraform.io/providers/cyrilgdn/postgresql/1.26.0/docs/resources/database) | resource |
| [postgresql_grant.baserow_database](https://registry.terraform.io/providers/cyrilgdn/postgresql/1.26.0/docs/resources/grant) | resource |
| [postgresql_grant.baserow_function](https://registry.terraform.io/providers/cyrilgdn/postgresql/1.26.0/docs/resources/grant) | resource |
| [postgresql_grant.baserow_schema](https://registry.terraform.io/providers/cyrilgdn/postgresql/1.26.0/docs/resources/grant) | resource |
| [postgresql_grant.baserow_sequence](https://registry.terraform.io/providers/cyrilgdn/postgresql/1.26.0/docs/resources/grant) | resource |
| [postgresql_grant.baserow_table](https://registry.terraform.io/providers/cyrilgdn/postgresql/1.26.0/docs/resources/grant) | resource |
| [postgresql_role.baserow](https://registry.terraform.io/providers/cyrilgdn/postgresql/1.26.0/docs/resources/role) | resource |
| [random_password.baserow_postgres_role](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.valkey](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster_auth.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |
| [aws_secretsmanager_secret.postgres_password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret) | data source |
| [aws_secretsmanager_secret_version.postgres_password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_az_count"></a> [az\_count](#input\_az\_count) | Number of AZs to use | `number` | `2` | no |
| <a name="input_client_vpn_cidr"></a> [client\_vpn\_cidr](#input\_client\_vpn\_cidr) | Client CIDR range for the Client VPN endpoint (must be /22 or /23 and non-overlapping) | `string` | `"10.250.0.0/22"` | no |
| <a name="input_client_vpn_enabled"></a> [client\_vpn\_enabled](#input\_client\_vpn\_enabled) | Whether to create the AWS Client VPN endpoint | `bool` | `true` | no |
| <a name="input_client_vpn_log_retention_days"></a> [client\_vpn\_log\_retention\_days](#input\_client\_vpn\_log\_retention\_days) | CloudWatch log retention in days for Client VPN connection logs | `number` | `30` | no |
| <a name="input_client_vpn_sso_group_id"></a> [client\_vpn\_sso\_group\_id](#input\_client\_vpn\_sso\_group\_id) | SSO group ID for Client VPN access | `string` | `"e3249852-c0a1-70c2-c87c-99436c0caa94"` | no |
| <a name="input_database_subnet_cidrs"></a> [database\_subnet\_cidrs](#input\_database\_subnet\_cidrs) | List of database subnet CIDRs (one per AZ) | `list(string)` | <pre>[<br>  "10.10.20.0/24",<br>  "10.10.21.0/24"<br>]</pre> | no |
| <a name="input_db_engine_version"></a> [db\_engine\_version](#input\_db\_engine\_version) | Aurora PostgreSQL engine version | `string` | `"17.5"` | no |
| <a name="input_db_instance_class"></a> [db\_instance\_class](#input\_db\_instance\_class) | DB instance class | `string` | `"db.t4g.medium"` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain name for Route53 record (e.g. example.com) | `string` | `"baserow-webinar.blackbird.cloud"` | no |
| <a name="input_eks_cluster_version"></a> [eks\_cluster\_version](#input\_eks\_cluster\_version) | EKS cluster version | `string` | `"1.33"` | no |
| <a name="input_eks_spot_node_desired_size"></a> [eks\_spot\_node\_desired\_size](#input\_eks\_spot\_node\_desired\_size) | Desired spot node count | `number` | `1` | no |
| <a name="input_eks_spot_node_instance_types"></a> [eks\_spot\_node\_instance\_types](#input\_eks\_spot\_node\_instance\_types) | Instance types for spot node group | `list(string)` | <pre>[<br>  "t3.xlarge"<br>]</pre> | no |
| <a name="input_eks_spot_node_max_size"></a> [eks\_spot\_node\_max\_size](#input\_eks\_spot\_node\_max\_size) | Maximum spot node count | `number` | `2` | no |
| <a name="input_eks_spot_node_min_size"></a> [eks\_spot\_node\_min\_size](#input\_eks\_spot\_node\_min\_size) | Minimum spot node count | `number` | `1` | no |
| <a name="input_eks_stable_node_desired_size"></a> [eks\_stable\_node\_desired\_size](#input\_eks\_stable\_node\_desired\_size) | Desired stable node count | `number` | `1` | no |
| <a name="input_eks_stable_node_instance_types"></a> [eks\_stable\_node\_instance\_types](#input\_eks\_stable\_node\_instance\_types) | Instance types for stable node group | `list(string)` | <pre>[<br>  "t3.xlarge"<br>]</pre> | no |
| <a name="input_eks_stable_node_max_size"></a> [eks\_stable\_node\_max\_size](#input\_eks\_stable\_node\_max\_size) | Maximum stable node count | `number` | `2` | no |
| <a name="input_eks_stable_node_min_size"></a> [eks\_stable\_node\_min\_size](#input\_eks\_stable\_node\_min\_size) | Minimum stable node count | `number` | `1` | no |
| <a name="input_elasticache_subnet_cidrs"></a> [elasticache\_subnet\_cidrs](#input\_elasticache\_subnet\_cidrs) | List of elasticache subnet CIDRs (one per AZ) | `list(string)` | <pre>[<br>  "10.10.30.0/24",<br>  "10.10.31.0/24"<br>]</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | Base name/prefix for all resources | `string` | `"baserow"` | no |
| <a name="input_private_subnet_cidrs"></a> [private\_subnet\_cidrs](#input\_private\_subnet\_cidrs) | List of private subnet CIDRs (one per AZ) | `list(string)` | <pre>[<br>  "10.10.10.0/24",<br>  "10.10.11.0/24"<br>]</pre> | no |
| <a name="input_public_subnet_cidrs"></a> [public\_subnet\_cidrs](#input\_public\_subnet\_cidrs) | List of public subnet CIDRs (one per AZ) | `list(string)` | <pre>[<br>  "10.10.0.0/24",<br>  "10.10.1.0/24"<br>]</pre> | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `"eu-central-1"` | no |
| <a name="input_ses_identity"></a> [ses\_identity](#input\_ses\_identity) | SES identity (domain or email) to verify and use for sending. | `string` | `"baserow-webinar.blackbird.cloud"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Common tags | `map(string)` | <pre>{<br>  "Project": "baserow",<br>  "Terraform": "true"<br>}</pre> | no |
| <a name="input_valkey_node_type"></a> [valkey\_node\_type](#input\_valkey\_node\_type) | Valkey / ElastiCache node type | `string` | `"cache.t4g.small"` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | VPC CIDR block | `string` | `"10.10.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aurora_endpoint"></a> [aurora\_endpoint](#output\_aurora\_endpoint) | The Aurora cluster primary endpoint. |
| <a name="output_aurora_reader_endpoint"></a> [aurora\_reader\_endpoint](#output\_aurora\_reader\_endpoint) | The Aurora cluster reader endpoint. |
| <a name="output_aurora_security_group_id"></a> [aurora\_security\_group\_id](#output\_aurora\_security\_group\_id) | The security group ID for the Aurora cluster. |
| <a name="output_database_subnets"></a> [database\_subnets](#output\_database\_subnets) | List of database subnet IDs. |
| <a name="output_eks_cluster_endpoint"></a> [eks\_cluster\_endpoint](#output\_eks\_cluster\_endpoint) | The endpoint for the EKS cluster. |
| <a name="output_eks_cluster_name"></a> [eks\_cluster\_name](#output\_eks\_cluster\_name) | The name of the EKS cluster. |
| <a name="output_elasticache_subnets"></a> [elasticache\_subnets](#output\_elasticache\_subnets) | List of ElastiCache subnet IDs. |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | List of private subnet IDs. |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | List of public subnet IDs. |
| <a name="output_rds_kms_key_arn"></a> [rds\_kms\_key\_arn](#output\_rds\_kms\_key\_arn) | KMS key ARN used for RDS/Aurora encryption |
| <a name="output_s3_bucket_name"></a> [s3\_bucket\_name](#output\_s3\_bucket\_name) | Naam van de S3 bucket voor Baserow data. |
| <a name="output_s3_kms_key_arn"></a> [s3\_kms\_key\_arn](#output\_s3\_kms\_key\_arn) | KMS key ARN used for S3 bucket encryption. |
| <a name="output_valkey_kms_key_arn"></a> [valkey\_kms\_key\_arn](#output\_valkey\_kms\_key\_arn) | KMS key ARN used for Valkey/ElastiCache encryption. |
| <a name="output_valkey_primary_endpoint"></a> [valkey\_primary\_endpoint](#output\_valkey\_primary\_endpoint) | The primary endpoint address of the ElastiCache cluster. |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC. |

## Running Costs
```
Project: main

 Name                                                                                                                                                      Monthly Qty  Unit                    Monthly Cost

 module.eks.module.eks_managed_node_group["stable"].aws_eks_node_group.this[0]
 └─ Instance usage (Linux/UNIX, on-demand, t3.xlarge)                                                                                                              730  hours                        $140.16

 module.client_vpn[0].aws_ec2_client_vpn_network_association.associations["hcl-01702e9beb30874c07511f805f215c4f2edda95df92a0d2cb9e49814f0b42635-0"]
 └─ Endpoint association                                                                                                                                           730  hours                         $73.00

 module.client_vpn[0].aws_ec2_client_vpn_network_association.associations["hcl-01702e9beb30874c07511f805f215c4f2edda95df92a0d2cb9e49814f0b42635-1"]
 └─ Endpoint association                                                                                                                                           730  hours                         $73.00

 module.eks.aws_eks_cluster.this[0]
 └─ EKS cluster                                                                                                                                                    730  hours                         $73.00

 module.aurora.aws_rds_cluster_instance.this["t4g-one"]
 ├─ Database instance (on-demand, db.t4g.medium)                                                                                                                   730  hours                         $62.05
 └─ Performance Insights API                                                                                                                         Monthly cost depends on usage: $0.01 per 1000 requests

 module.aurora.aws_rds_cluster_instance.this["t4g-two"]
 ├─ Database instance (on-demand, db.t4g.medium)                                                                                                                   730  hours                         $62.05
 └─ Performance Insights API                                                                                                                         Monthly cost depends on usage: $0.01 per 1000 requests

 module.eks.module.eks_managed_node_group["spot"].aws_eks_node_group.this[0]
 └─ Instance usage (Linux/UNIX, spot, t3.xlarge)                                                                                                                   730  hours                         $56.06

 module.valkey.aws_elasticache_replication_group.this[0]
 └─ ElastiCache (on-demand, cache.t4g.small)                                                                                                                     1,460  hours                         $42.05

 module.vpc.aws_nat_gateway.this[0]
 ├─ NAT gateway                                                                                                                                                    730  hours                         $37.96
 └─ Data processed                                                                                                                                   Monthly cost depends on usage: $0.052 per GB

 module.vpc.aws_nat_gateway.this[1]
 ├─ NAT gateway                                                                                                                                                    730  hours                         $37.96
 └─ Data processed                                                                                                                                   Monthly cost depends on usage: $0.052 per GB

 module.client_vpn[0].aws_ec2_client_vpn_endpoint.vpn
 └─ Connection                                                                                                                                                     730  hours                         $36.50

 module.waf.aws_wafv2_web_acl.default[0]
 ├─ Web ACL usage                                                                                                                                                    1  months                         $5.00
 └─ Requests                                                                                                                                         Monthly cost depends on usage: $0.60 per 1M requests

 aws_kms_key.backup
 ├─ Customer master key                                                                                                                                              1  months                         $1.00
 ├─ Requests                                                                                                                                         Monthly cost depends on usage: $0.03 per 10k requests
 ├─ ECC GenerateDataKeyPair requests                                                                                                                 Monthly cost depends on usage: $0.10 per 10k requests
 └─ RSA GenerateDataKeyPair requests                                                                                                                 Monthly cost depends on usage: $0.10 per 10k requests

 aws_kms_key.rds
 ├─ Customer master key                                                                                                                                              1  months                         $1.00
 ├─ Requests                                                                                                                                         Monthly cost depends on usage: $0.03 per 10k requests
 ├─ ECC GenerateDataKeyPair requests                                                                                                                 Monthly cost depends on usage: $0.10 per 10k requests
 └─ RSA GenerateDataKeyPair requests                                                                                                                 Monthly cost depends on usage: $0.10 per 10k requests

 aws_kms_key.s3
 ├─ Customer master key                                                                                                                                              1  months                         $1.00
 ├─ Requests                                                                                                                                         Monthly cost depends on usage: $0.03 per 10k requests
 ├─ ECC GenerateDataKeyPair requests                                                                                                                 Monthly cost depends on usage: $0.10 per 10k requests
 └─ RSA GenerateDataKeyPair requests                                                                                                                 Monthly cost depends on usage: $0.10 per 10k requests

 aws_kms_key.valkey
 ├─ Customer master key                                                                                                                                              1  months                         $1.00
 ├─ Requests                                                                                                                                         Monthly cost depends on usage: $0.03 per 10k requests
 ├─ ECC GenerateDataKeyPair requests                                                                                                                 Monthly cost depends on usage: $0.10 per 10k requests
 └─ RSA GenerateDataKeyPair requests                                                                                                                 Monthly cost depends on usage: $0.10 per 10k requests

 module.eks.module.kms.aws_kms_key.this[0]
 ├─ Customer master key                                                                                                                                              1  months                         $1.00
 ├─ Requests                                                                                                                                         Monthly cost depends on usage: $0.03 per 10k requests
 ├─ ECC GenerateDataKeyPair requests                                                                                                                 Monthly cost depends on usage: $0.10 per 10k requests
 └─ RSA GenerateDataKeyPair requests                                                                                                                 Monthly cost depends on usage: $0.10 per 10k requests

 aws_route53_zone.public
 └─ Hosted zone                                                                                                                                                      1  months                         $0.50

 aws_cloudwatch_log_group.client_vpn[0]
 ├─ Data ingested                                                                                                                                    Monthly cost depends on usage: $0.63 per GB
 ├─ Archival Storage                                                                                                                                 Monthly cost depends on usage: $0.0324 per GB
 └─ Insights queries data scanned                                                                                                                    Monthly cost depends on usage: $0.0063 per GB

 aws_cloudwatch_log_group.waf
 ├─ Data ingested                                                                                                                                    Monthly cost depends on usage: $0.63 per GB
 ├─ Archival Storage                                                                                                                                 Monthly cost depends on usage: $0.0324 per GB
 └─ Insights queries data scanned                                                                                                                    Monthly cost depends on usage: $0.0063 per GB

 aws_route53_record.dkim[0]
 ├─ Standard queries (first 1B)                                                                                                                      Monthly cost depends on usage: $0.40 per 1M queries
 ├─ Latency based routing queries (first 1B)                                                                                                         Monthly cost depends on usage: $0.60 per 1M queries
 └─ Geo DNS queries (first 1B)                                                                                                                       Monthly cost depends on usage: $0.70 per 1M queries

 aws_route53_record.dkim[1]
 ├─ Standard queries (first 1B)                                                                                                                      Monthly cost depends on usage: $0.40 per 1M queries
 ├─ Latency based routing queries (first 1B)                                                                                                         Monthly cost depends on usage: $0.60 per 1M queries
 └─ Geo DNS queries (first 1B)                                                                                                                       Monthly cost depends on usage: $0.70 per 1M queries

 aws_route53_record.dkim[2]
 ├─ Standard queries (first 1B)                                                                                                                      Monthly cost depends on usage: $0.40 per 1M queries
 ├─ Latency based routing queries (first 1B)                                                                                                         Monthly cost depends on usage: $0.60 per 1M queries
 └─ Geo DNS queries (first 1B)                                                                                                                       Monthly cost depends on usage: $0.70 per 1M queries

 aws_route53_record.dmarc
 ├─ Standard queries (first 1B)                                                                                                                      Monthly cost depends on usage: $0.40 per 1M queries
 ├─ Latency based routing queries (first 1B)                                                                                                         Monthly cost depends on usage: $0.60 per 1M queries
 └─ Geo DNS queries (first 1B)                                                                                                                       Monthly cost depends on usage: $0.70 per 1M queries

 module.acm.aws_route53_record.validation[0]
 ├─ Standard queries (first 1B)                                                                                                                      Monthly cost depends on usage: $0.40 per 1M queries
 ├─ Latency based routing queries (first 1B)                                                                                                         Monthly cost depends on usage: $0.60 per 1M queries
 └─ Geo DNS queries (first 1B)                                                                                                                       Monthly cost depends on usage: $0.70 per 1M queries

 module.aurora.aws_rds_cluster.this[0]
 ├─ Storage                                                                                                                                          Monthly cost depends on usage: $0.12 per GB
 ├─ I/O requests                                                                                                                                     Monthly cost depends on usage: $0.22 per 1M requests
 ├─ Backup storage                                                                                                                                   Monthly cost depends on usage: $0.023 per GB
 └─ Snapshot export                                                                                                                                  Monthly cost depends on usage: $0.011 per GB

 module.backup.aws_backup_vault.vault
 ├─ EFS backup (warm)                                                                                                                                Monthly cost depends on usage: $0.06 per GB
 ├─ EFS backup (cold)                                                                                                                                Monthly cost depends on usage: $0.012 per GB
 ├─ EFS restore (warm)                                                                                                                               Monthly cost depends on usage: $0.024 per GB
 ├─ EFS restore (cold)                                                                                                                               Monthly cost depends on usage: $0.036 per GB
 ├─ EFS restore (item-level)                                                                                                                         Monthly cost depends on usage: $0.60 per requests
 ├─ EBS snapshot                                                                                                                                     Monthly cost depends on usage: $0.054 per GB
 ├─ RDS snapshot                                                                                                                                     Monthly cost depends on usage: $0.10 per GB
 ├─ DynamoDB backup                                                                                                                                  Monthly cost depends on usage: $0.12 per GB
 ├─ DynamoDB restore                                                                                                                                 Monthly cost depends on usage: $0.18 per GB
 ├─ Aurora snapshot                                                                                                                                  Monthly cost depends on usage: $0.023 per GB
 ├─ FSx for Windows backup                                                                                                                           Monthly cost depends on usage: $0.054 per GB
 └─ FSx for Lustre backup                                                                                                                            Monthly cost depends on usage: $0.054 per GB

 module.eks.aws_cloudwatch_log_group.this[0]
 ├─ Data ingested                                                                                                                                    Monthly cost depends on usage: $0.63 per GB
 ├─ Archival Storage                                                                                                                                 Monthly cost depends on usage: $0.0324 per GB
 └─ Insights queries data scanned                                                                                                                    Monthly cost depends on usage: $0.0063 per GB

 module.s3_bucket.aws_s3_bucket.this[0]
 └─ Standard
    ├─ Storage                                                                                                                                       Monthly cost depends on usage: $0.0245 per GB
    ├─ PUT, COPY, POST, LIST requests                                                                                                                Monthly cost depends on usage: $0.0054 per 1k requests
    ├─ GET, SELECT, and all other requests                                                                                                           Monthly cost depends on usage: $0.00043 per 1k requests
    ├─ Select data scanned                                                                                                                           Monthly cost depends on usage: $0.00225 per GB
    └─ Select data returned                                                                                                                          Monthly cost depends on usage: $0.0008 per GB

 module.valkey.aws_cloudwatch_log_group.this["slow-log"]
 ├─ Data ingested                                                                                                                                    Monthly cost depends on usage: $0.63 per GB
 ├─ Archival Storage                                                                                                                                 Monthly cost depends on usage: $0.0324 per GB
 └─ Insights queries data scanned                                                                                                                    Monthly cost depends on usage: $0.0063 per GB

 OVERALL TOTAL                                                                                                                                                                                      $704.29

*Usage costs can be estimated by updating Infracost Cloud settings, see docs for other options.

──────────────────────────────────
158 cloud resources were detected:
∙ 30 were estimated
∙ 127 were free
∙ 1 is not supported yet, rerun with --show-skipped to see details

┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━┳━━━━━━━━━━━━┓
┃ Project                                            ┃ Baseline cost ┃ Usage cost* ┃ Total cost ┃
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╋━━━━━━━━━━━━━━━╋━━━━━━━━━━━━━╋━━━━━━━━━━━━┫
┃ main                                               ┃          $704 ┃           - ┃       $704 ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┻━━━━━━━━━━━━━━━┻━━━━━━━━━━━━━┻━━━━━━━━━━━━┛
```
Update with
```sh
infracost breakdown --format=table --no-color --path . --out-file=costs.md
```

## About

We are [Blackbird Cloud](https://blackbird.cloud), Amsterdam based cloud consultancy, and cloud management service provider. We help companies build secure, cost efficient, and scale-able solutions.

Checkout our other :point\_right: [terraform modules](https://registry.terraform.io/namespaces/blackbird-cloud)

## Copyright

Copyright © 2017-2025 [Blackbird Cloud](https://blackbird.cloud)

[![blackbird-logo](https://raw.githubusercontent.com/blackbird-cloud/terraform-module-template/main/.config/logo_simple.png)](https://blackbird.cloud)
