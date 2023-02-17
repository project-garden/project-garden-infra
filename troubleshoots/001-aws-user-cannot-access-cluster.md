# AWS User Cannot Access Cluster

## 😲 Issue

EKS Admin cannot access the kubernetes cluster via `kubectl`. It's happened after we use `terraform` credential to spawn the cluster


## 💡 Solution / Workaround

* After cluster creation, access cluster with `terraform/cluster creation` aws creds
* Edit `aws-auth` configmap with this command
```bash
kubectl edit -n kube-system configmap/aws-auth
```

* Add this `MapUsers` bellow `MapRoles` section

```bash
apiVersion: v1
data:
  mapRoles: |
    ...
    - here goes MapRoles section
    ...
  mapUsers: |
    - groups:
      - system:masters
      userarn: arn:aws:iam::229475678484:user/husni-development
      username: husni-development
    - groups:
      - system:masters
      userarn: arn:aws:iam::229475678484:user/idan-development
      username: idan-development
```

## 🚀 Improvment Ideas

* Need to look out how to inject roles/user to `aws-auth` configmap after cluster creation

## 📖 References

* [How do I resolve the error "You must be logged in to the server (Unauthorized)" when I connect to the Amazon EKS API server?](https://aws.amazon.com/premiumsupport/knowledge-center/eks-api-server-unauthorized-error/)

* [Amazon EKS identity-based policy examples](https://docs.aws.amazon.com/eks/latest/userguide/security_iam_id-based-policy-examples.html#policy-create-cluster)

* [Manage EKS aws-auth configmap with terraform ](https://dev.to/fukubaka0825/manage-eks-aws-auth-configmap-with-terraform-4ndp)