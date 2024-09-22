### 1. **创建 GKE 集群**

- **选择区域或地区**：
  GKE 集群必须在特定的 GCP 区域或地区内创建。你可以列出可用的区域：
  
  ```bash
  gcloud compute regions list
  ```

- **创建 GKE 集群**：
  通过以下命令创建一个简单的 GKE 集群：
  
  ```bash
  gcloud container clusters create my-gke-cluster \\
    --zone us-central1-a \\
    --num-nodes 3 \\
    --enable-ip-alias
  ```
  
  - `my-gke-cluster` 是你的集群名称。
  - `-zone` 是你选择的地理位置。
  - `-num-nodes` 表示初始节点数量，通常 3 是适合的小型集群。
  - `-enable-ip-alias` 启用 VPC-native 网络（推荐）。

- **验证集群创建**：
  确认集群已成功创建，并列出可用的集群：
  
  ```bash
  gcloud container clusters list
  ```

### 2. **连接到 GKE 集群**

- 使用 `gcloud` 命令配置 `kubectl` 工具以连接到集群：
  
  ```bash
  gcloud container clusters get-credentials my-gke-cluster --zone us-central1-a
  ```
  
  现在你可以使用 `kubectl` 与集群进行交互。

- 验证连接：
  
  ```bash
  kubectl get nodes
  ```
  
  你应该能看到集群中的节点列表。

### 3. **部署应用程序**

- **创建部署文件**：
  创建一个 Kubernetes 配置文件（如 `deployment.yaml`），并使用 `kubectl` 命令部署应用程序。例如，下面是一个简单的 Nginx 部署文件：
  
  ```yaml
  apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: nginx-deployment
  spec:
    replicas: 2
    selector:
      matchLabels:
        app: nginx
    template:
      metadata:
        labels:
          app: nginx
      spec:
        containers:
        - name: nginx
          image: nginx:1.14.2
          ports:
          - containerPort: 80
  ```
  
  - 使用 `kubectl apply` 部署应用：
    
    ```bash
    kubectl apply -f deployment.yaml
    ```

- **检查部署**：
  确认部署和运行的 Pod：
  
  ```bash
  kubectl get pods
  ```

### 4. **公开服务**

- **创建服务文件**：
  创建一个 `service.yaml` 文件以暴露部署的服务。例如，使用 LoadBalancer 暴露 Nginx 部署：
  
  ```yaml
  apiVersion: v1
  kind: Service
  metadata:
    name: nginx-service
  spec:
    type: LoadBalancer
    selector:
      app: nginx
    ports:
      - protocol: TCP
        port: 80
        targetPort: 80
  ```
  
  - 使用以下命令应用该服务：
    
    ```bash
    kubectl apply -f service.yaml
    ```

- **获取外部 IP**：
  GKE 会分配一个外部 IP 地址来访问该服务。通过以下命令获取：在几分钟内，你将看到一个分配的 `EXTERNAL-IP`，你可以通过这个地址访问你的应用程序。
  
  ```bash
  kubectl get service nginx-service
  ```

### 5. **监控和扩展集群**

- **自动扩展**：
  你可以启用自动扩展器来根据负载增加或减少节点：
  
  ```bash
  gcloud container clusters update my-gke-cluster \\
    --enable-autoscaling \\
    --min-nodes 1 \\
    --max-nodes 5 \\
    --zone us-central1-a
  ```

- **监控工具**：
  使用 GCP 提供的 `Stackdriver` 监控和日志工具来监控集群的健康状况和性能：
  
  - 导航到 `Monitoring` 部分设置 Kubernetes Dashboard。
  
  - 或者使用 `kubectl` 查看日志：
    
    ```bash
    kubectl logs <pod-name>
    ```

### 6. **删除 Service**

首先，查看当前存在的服务列表，确认你要删除的服务：

```bash
kubectl get services
```

找到你想删除的服务名称后，使用以下命令删除它（假设服务名称是 `nginx-service`）：

```bash
kubectl delete service nginx-service
```

这将删除暴露的 `Service`，并释放外部 IP 地址。

### 7. **删除 Deployment**

同样，先检查现有的 Deployment 列表：

```bash
kubectl get deployments
```

找到你想删除的 Deployment 名称（假设是 `nginx-deployment`），然后使用以下命令删除它：

```bash
kubectl delete deployment nginx-deployment
```

这将删除相关的 Deployment 以及其创建的所有 Pod 和 ReplicaSet。

### 8. **确认删除**

你可以再次使用 `kubectl get services` 和 `kubectl get deployments` 来确认它们已被删除：

```bash
kubectl get services
kubectl get deployments
删除集群
gcloud container clusters delete my-gke-cluster --zone us-central1-a
```
