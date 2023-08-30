**This repository creates EKS(AWS) cluster**

- Default region is us-west-2 (Modify variables.tf file)
- Uses private subnets for worker nodes
- instance_types is t3.small
- Post cluster is alive, run kubectl apply -f efs-csi-driver.yaml. This will install the driver, will create ClusterRole,   
  ClusterRoleBinding required to bind efs with eks cluster.
- Deployment file should have code to create storageclass, pv and pvc.
**Example:**
  <sub>
apiVersion: v1
kind: PersistentVolume
metadata:
  name: efs-pv
spec:
  capacity:
    storage: 10Gi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: efs-sc
  csi:
    driver: efs.csi.aws.com
    volumeHandle: fs-0a17c15206714bd2a.efs.us-west-2.amazonaws.com

---
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: efs-sc
provisioner: efs.csi.aws.com
parameters:
  provisioningMode: efs-ap
  fileSystemId: fs-0a17c15206714bd2a
  directoryPerms: "777"

---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mysql-pvc
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: efs-sc
  resources:
    requests:
      storage: 2Gi
  </sub>

NOTE: This will create EBS volume in single az, If the worker node post restart comes up on a different az other than where your EBS volume is, then MySQL pod won't come up.

Reference: https://github.com/hashicorp/learn-terraform-provision-eks-cluster/blob/main/main.tf
