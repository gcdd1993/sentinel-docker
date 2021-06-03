# 构建

```bash
docker build -f Dockerfile -t gcdd1993/sentinel-dashboard:1.8.1 .
```

或者可以直接使用[gcdd1993/sentinel-dashboard](https://hub.docker.com/r/gcdd1993/sentinel-dashboard)

# Helm 部署

```bash
$ helm repo add sentinel-dashboard https://github.com/gcdd1993/sentinel-docker/tree/master/helm-charts/sentinel-dashboard
$ helm install sentinel-dashboard sentinel-dashboard
```

## 配置

```properties
config.username=sentinel // sentinel dashboard 用户名
config.password=sentinel // sentinel dashboard 密码

image.repository=gcdd1993/sentinel-dashboard
image.tag=1.8.1

services.http.type=ClusterIP // 可以修改为NodePort以便于集群外部访问
services.ports.default.port=8080 // 应用端口
services.ports.default.nodePort=30000 // service type = NodePort时生效，集群外部访问端口

ingress.enabled=false
ingress.path=/
ingress.hosts=[chart-example.local]
```