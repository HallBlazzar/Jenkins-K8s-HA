# Jenkins-K8s-HA

This is the sub-project of `kubeadm-CDK`(https://github.com/HallBlazzar/kubeadm-CDK), which deploys highly available Jenkins master node on top of K8s cluster created by `kubeadm-CDK` project.

## Quick Start

1. Deploy K8s cluster through instruction in `kubeadm-CDK`.

2. After deployment finished, SSH to manager instance.

3. Clone this repository.

4. Switch working directory to the path(`REPOSITORY_PATH`) you clone this repository.

   ```
   cd REPOSITORY_PATH
   ```

5. Enable execute permission of `deploy.sh`

   ```
   chmod +x deploy.sh
   ```

6. Execute `deploy.sh`

   ```
   ./deploy.sh
   ```

7. Check deployment status through:

   ```
   kubectl get pods
   ```

   Once Jenkins Pod and Pod containers ready, check node port exposed by:

   ```
   kubectl get svc
   ```

   And access arbitrary worker node's public IP address with node port through your browser. The default user name is `admin`, and password could be retrieved via command below:

   ```
   printf $(kubectl get secret --namespace default jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode);echo
   ```

   Enjoy it!

## How it works

To construct highly available Jenkins cluster, shared storage is required. By default, Jenkins is not designed for HA architecture. Once master node is removed, all configuration and pipelines will lose. To prevent the disaster, use a share storage to persistently store Jenkins' settings is required. 

In `kubeadm-CDK` project, a containerized Rook-Ceph cluster is deployed in the K8s cluster. This project use the Ceph filesystem StorageClass provisioned by Rook to provide Jenkins Pod a persistent storage to place configuration to allow HA Jenkins. Once you delete Jenkins Pod via:

``` 
kubectl delete pod
```

New Jenkins Pod will be provisioned by Deployment, and settings and pipelines will still be retained and accessible by new Pod.

This project is inspired by the [AWS official blog post topic](https://aws.amazon.com/blogs/storage/deploying-jenkins-on-amazon-eks-with-amazon-efs/) and the [Jenkins Helm Chart](https://github.com/helm/charts/tree/master/stable/jenkins).

