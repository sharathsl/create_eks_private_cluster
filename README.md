**This repository creates EKS(AWS) cluster**

- Default region is us-west-2 (Modify variables.tf file)
- Uses private subnets for worker nodes
- instance_types is t3.small
- Configures ebs-csi-driver for you to claim ebs storage using kubernetes PersistentVolumeClaim

NOTE: This will create ebs volume in single az, if worker node post restart come up on different az other than where your ebs volume is, then mysql pod won't come up.

Reference: https://github.com/hashicorp/learn-terraform-provision-eks-cluster/blob/main/main.tf
