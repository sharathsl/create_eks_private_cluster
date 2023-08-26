**This repository creates EKS(AWS) cluster**

- Default region is us-west-2 (Modify variables.tf file)
- Uses private subnets for worker nodes
- instance_types is t3.small
- Configures ebs-csi-driver for you to claim EBS storage using Kubernetes PersistentVolumeClaim

NOTE: This will create EBS volume in single az, If the worker node post restart comes up on a different az other than where your EBS volume is, then MySQL pod won't come up.

Reference: https://github.com/hashicorp/learn-terraform-provision-eks-cluster/blob/main/main.tf
