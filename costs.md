Project: main

 Name                                                                                                                                                      Monthly Qty  Unit                    Monthly Cost

 module.eks.module.eks_managed_node_group["stable"].aws_eks_node_group.this[0]
 └─ Instance usage (Linux/UNIX, on-demand, t3.xlarge)                                                                                                            1,460  hours                        $280.32

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

 OVERALL TOTAL                                                                                                                                                                                      $782.39

*Usage costs can be estimated by updating Infracost Cloud settings, see docs for other options.

──────────────────────────────────
137 cloud resources were detected:
∙ 25 were estimated
∙ 111 were free
∙ 1 is not supported yet, rerun with --show-skipped to see details

┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━┳━━━━━━━━━━━━┓
┃ Project                                            ┃ Baseline cost ┃ Usage cost* ┃ Total cost ┃
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╋━━━━━━━━━━━━━━━╋━━━━━━━━━━━━━╋━━━━━━━━━━━━┫
┃ main                                               ┃          $782 ┃           - ┃       $782 ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┻━━━━━━━━━━━━━━━┻━━━━━━━━━━━━━┻━━━━━━━━━━━━┛
