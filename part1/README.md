
# README
This README contains information the solution of a following challenge:
> Create your own application. This proof of concept is used to demonstrate the technical feasibility of hosting, managing,
and scaling the platform and is not about content.



## Requirements

- [Helm](https://helm.sh/docs/intro/install/) - This guide shows how to install the Helm CLI. Helm can be installed either from source, or from pre-built binary releases.
- [Kubernetes cluster](https://kubernetes.io/) - Existing cluster created in either cloud (e.g - AWS, GCP, etc) or on-prem environment.
- [Kubectl](https://kubernetes.io/docs/reference/kubectl/) - Kubernetes provides a command line tool for communicating with a Kubernetes cluster's control plane, using the Kubernetes API.
- [Ingress Controller](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/) - In order for the Ingress resource to work, the cluster must have an ingress controller running. Based on the pre-installed controller, the correct 'ingress.class' should be defined.

## Setup

To setup the application, we need to:

1 - Clone the repo:
```bash
    git clone https://github.com/barzanov/tech-challenge.git
```
2 - Navigate to the appChart folder:
```bash
    cd ./part1/appChart
```

3 - Review the properties set in the 'values.yaml' file. If needed, make changes.

4 - Install the helm-release:
```bash
    upgrade --install --history-max 10 <INSERT-CHART-NAME> . --namespace <INSERT-NAMESPACE-NAME> -f ./values.yaml
```

5 - Verify the web app was successfully deployed:
```bash
    kubectl get pods -n <INSERT-NAMESPACE-NAME>
```

## Scaling
The scaling of this service is managed by HPA object in K8S. It is based on:
- CPU consumption    -- which can be adjusted in the 'values.yaml' file
- MEMORY consumption -- which also can be adjusted in the 'values.yaml' file
```yaml
hpa:
  cpu:
    averageUtilization: 85
  memory:
    averageUtilization: 85
```

## Configurations

The setup allows for an easy webapp update or nginx configuration changes.

1 - To update the web app, navigate to the following directory:
```bash
    cd ./part1/appChart/webapp
```
Then edit the following file - 'index.html'. Once completed, upgrade the helm chart:
```bash
    upgrade --install --history-max 10 <INSERT-CHART-NAME> . --namespace <INSERT-NAMESPACE-NAME> -f ./values.yaml
```
The service will restart and apply the changes.

2 - To update the configuration of the nginx service, navigate to:
```bash
    cd ./part1/appChart/webapp
```
Then edit the following file - 'nginx.conf'. Once completed, upgrade the helm chart:
```bash
    upgrade --install --history-max 10 <INSERT-CHART-NAME> . --namespace <INSERT-NAMESPACE-NAME> -f ./values.yaml
```
The service will restart and apply the changes.


## Automations

As of writing this README, the deployment process of the web app is manual. 
Once agreed upon a preferred tool and environment, the process can be automated with tools like Jenkins, Github actions, etc.

An example of such setup (assuming there is an existing EKS cluster, which can be accessed by GitHub):
```yaml
on:
 
  push:
    branches: [ main ]
  workflow_dispatch:env:
  EKS_CLUSTER_NAME: test-cluster
  AWS_REGION: us-east-1
  
  build:
    name: Deployment
    runs-on: ubuntu-latest    
    steps:    
    - name: Configure AWS credentials
      uses: aws-actions/configure-aws-credentials@v1
      with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: ${{env.AWS_REGION}}    
          
    - name: Update kube config
      run: aws eks update-kubeconfig --name $EKS_CLUSTER_NAME --region $AWS_REGION    

    - name: Deploy helm chart
      uses: WyriHaximus/github-action-helm3@v3
      with:
        exec: helm upgrade --install --history-max 10 <INSERT-CHART-NAME> appChart/ -f appChart/values.yaml
```