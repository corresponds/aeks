### Introduction

In this lab step, you'll examine and review the EKS cluster 
configuration which has already been performed (part of the lab launch 
script). In particular, you'll review the configuration 
prerequisites required in preparation for you deploying the [AWS Load Balancer Controller](https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.4/), to be done in next the lab step.

**Note**: All commands presented below have already been performed and are shown for review only. 

### Review

1. The EKS cluster provided within this lab has been provisioned using the [eksctl](https://eksctl.io/) utility. The cluster was created with the following script and settings: 

`eksctl create cluster \`

`--version=1.28 \`

`--name=Cluster-1 \`

`--nodes=1 \`

`--node-type=t2.medium \`

`--ssh-public-key="cloudacademylab" \`

`--region=us-west-2 \`

`--zones=us-west-2a,us-west-2b,us-west-2c \`

`--node-volume-type=gp2 \`

`--node-volume-size=20`

2. In preparation for deploying the [AWS Load Balancer Controller](https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.4/), the following configurations are required.

2.1. An OpenID Connect provider needs to be established. This was performed using the following command: 

`eksctl utils associate-iam-oidc-provider \`

`--region us-west-2 \`

`--cluster Cluster-1 \`

`--approve`

2.2. A new IAM Policy was created, providing various permissions 
required to provision the underlying infrastructure items (ALBs and/or 
NLBs) created when Ingress and Service cluster resources are created.

**Note**: You can view the specific set of IAM permissions granted here:

https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json

`curl -o /tmp/iam_policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json`

`aws iam create-policy \`

`--policy-name AWSLoadBalancerControllerIAMPolicy \`

`--policy-document file:///tmp/iam_policy.json`

2.3. A new cluster service account bound to the IAM policy has been
 created. When the AWS Load Balancer controller is later deployed by 
you, it will be configured to operate with this service account:

`eksctl create iamserviceaccount \`

`--cluster Cluster-1 \`

`--namespace kube-system \`

`--name aws-load-balancer-controller \`

`--attach-policy-arn arn:aws:iam::${AWS::AccountId}:policy/AWSLoadBalancerControllerIAMPolicy \`

`--override-existing-serviceaccounts \`

`--approve`

### Summary

In this lab step, you reviewed the EKS cluster configuration 
performed at lab launch time in preparation for the deployment of the [AWS Load Balancer Controller](https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.4/), which you will perform in the next lab step.
