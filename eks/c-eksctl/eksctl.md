To install an EKS cluster from scratch following the provided steps using `eksctl`, here is how you can replicate the same configuration on your own:

### Step 1: Install `eksctl`

Make sure you have `eksctl` installed on your system. If not, you can install it with the following command:

```shell
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin

```

### Step 2: Create the EKS Cluster

You can create the EKS cluster by running the following command. Adjust the `--ssh-public-key` parameter to use your own key if needed:

```
eksctl create cluster \
  --version=1.28 \
  --name=Cluster-1 \
  --nodes=1 \
  --node-type=t2.medium \
  --ssh-public-key="gekas-public-key" \
  --region=us-west-2 \
  --zones=us-west-2a,us-west-2b,us-west-2c \
  --node-volume-type=gp2 \
  --node-volume-size=20

```

This command will create an EKS cluster with the specified settings, including 1 node, in the `us-west-2` region.

### Step 3: Associate IAM OIDC Provider

After the cluster is created, you need to associate an OpenID Connect (OIDC) provider to allow AWS IAM roles to be assumed by Kubernetes service accounts. Run the following command:

```
eksctl utils associate-iam-oidc-provider \
  --region us-west-2 \
  --cluster Cluster-1 \
  --approve
```

### Step 5: Create IAM Service Account

Finally, you need to create an IAM service account bound to the IAM policy created in the previous step. This service account will be used by the AWS Load Balancer Controller:

```
eksctl create iamserviceaccount \
  --cluster Cluster-1 \
  --namespace kube-system \
  --name aws-load-balancer-controller \
  --attach-policy-arn arn:aws:iam::<your-account-id>:policy/AWSLoadBalancerControllerIAMPolicy \
  --override-existing-serviceaccounts \
  --approve

```

Replace `<your-account-id>` with your actual AWS account ID.

### Summary of Commands

- Install `eksctl`
- Create the EKS cluster
- Associate IAM OIDC provider
- Create IAM policy for AWS Load Balancer Controller
- Create IAM service account for the controller

This will set up the EKS cluster and prepare it for deploying the AWS Load Balancer Controller in the next lab step.
