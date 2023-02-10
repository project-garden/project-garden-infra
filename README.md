# 🪴 Project Garden Infrastructure Resources

This will setup an elastic kuberentes cluster with 2 node groups, an isolated vpc, and their security groups. The infrastructure resources will grow with time

## ✅ Pre-requisites

* aws-cli [[install](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html), [quick setup](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-quickstart.html), [docs](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html)]
* gcloud cli [[install](https://cloud.google.com/sdk/docs/install-sdk), [quick setup](https://cloud.google.com/sdk/docs/initializing), [docs](https://cloud.google.com/sdk/gcloud)]
* kubectl [[install](https://kubernetes.io/docs/tasks/tools/), [docs](https://kubernetes.io/docs/home/)]
* helm [[install](https://helm.sh/docs/intro/install/), [docs](https://helm.sh/docs/)]
* terraform [[install](https://developer.hashicorp.com/terraform/downloads), [docs](https://developer.hashicorp.com/terraform/docs)]
* minikube(dev) [[install](https://minikube.sigs.k8s.io/docs/start/), [docs](https://minikube.sigs.k8s.io/docs/)]

## 🤔 How To Use?

* Get AWS Access Key and Secret Key from `Google Secret Manager`

```bash
export AWS_ACCESS_KEY_ID=$(gcloud secrets versions access 2 --secret=project-garden-terraform-secret-key | jq -r '.[0].ACCESS_ID')

export AWS_SECRET_ACCESS_KEY=$(gcloud secrets versions access 2 --secret=project-garden-terraform-secret-key | jq -r '.[0].SECRET_KEY')
```

* Start Terraform

```bash
terraform init

terraform apply
```

* Configure `kubectl`

```bash
# Define your AWS CLI Profile
PROFILE=your_aws_cli_profile

# Accessing Cluster Credential
aws eks update-kubeconfig \
    --region $(terraform output -raw region) \
    --name $(terraform output -raw cluster_name) \
    --profile $PROFILE

# Verify
kubectl cluster-info
```

* (**Additional**) SSH to VM
```bash
# All private key is located in .private folder (learning-cluster/infrastructure/.private)
chmod 400 .private/hello_world_vm.pem

ssh -i .private/hello_world_vm.pem ubuntu@$(terraform output -raw ec2_instance_public_ip)
```
* Cleanup

    🚨 Make sure to delete all **Service** (ClusterIP, LoadBalancer, etc) and Deployments before proceed to Clean Up

    🚨 Or terraform cannot complete de destroying process

    ```bash
    terraform destroy
    ```

## 🛟 Minikube for Development Environment infra
Other way to create learning cluster is using `minikube`.

```bash
# Start a cluster with version 1.24.9
# (Required for current istio version)
minikube start --kubernetes-version=v1.24.9

# Create a tunnel to bridge beetwen local <-> minikube cluster
# DON'T CLOSE THE TERMINAL!
minikube tunnel
```

## 📚 References

* [How can I tag the Amazon VPC subnets in my Amazon EKS cluster for automatic subnet discovery by load balancers or ingress controllers?](https://aws.amazon.com/premiumsupport/knowledge-center/eks-vpc-subnet-discovery/)

* [Provisioning Kubernetes clusters on AWS with Terraform and EKS](https://learnk8s.io/terraform-eks#testing-the-cluster-by-deploying-a-simple-hello-world-app)

* [Provider produced inconsistent final plan / an invalid new value for .tags_all](https://github.com/hashicorp/terraform-provider-aws/issues/19583)