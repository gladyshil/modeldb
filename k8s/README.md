# Running ModelDB with Kubernetes

Get a modeldb server up and running with Kubernetes on Docker-for-Desktop. 

 **Prerequisites**

Make sure you have [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) installed. 
 
1. **Clone the repo**

    ```bash
    git clone https://github.com/gladyshil/modeldb/tree/kubernetes
    ```

2. **Create the Persistent Volume Claim**

To be able to store our data and our models, we need to create a persistent volume claim. 

  ```bash
  cd modeldb/k8s
  kubectl apply -f pvc-modeldb.yaml
  ```
We then need to create a dummy pod to upload the files that will store our data in our backend pod. 

  ```bash
  kubectl apply -f pod-modeldb.yaml
  cd ../server/codegen
  kubectl cp db mypod:/thevol
  ```

3. **Create the Mongo Server**

We also need to set up our mongo server with kubernetes. 

  ```bash
  cd modeldb/k8s
  kubectl apply -f mongo.yaml
  ```
This will create a mongo deployment, service, persistent volume claim and secret. There is also an option to set up mongo authentication for the server 

4. **Create the frontend and backend**

Now that we have the files mounted onto the persistent volume claim, we don't need to dummy pod anymore. We can delete the pod and create our frontend and backend deployments.

  ```bash
  kubectl delete pod mypod
  kubectl create -f backend-deployment.yaml
  kubectl create -f frontend-deployment.yaml
  ```

We also need kubernetes services for these deployments. This will allow the frontend to be shown on our browser. It also allows our frontend to connect to our backend and the backend to connect to the mongo server. 

  ```bash
  kubectl expose deployment backend --type=LoadBalancer
  kubectl expose deployment frontend --type=LoadBalancer
  ```

`kubectl get all` will allow you to see all your pods, deployments, and services. `kubectl logs [pod_name]` allows you to see what's going on in your pod and can help with troubleshooting. `kubectl get deployment [name of deployment] -oyaml` lets you look at the file of the deployment that's running.  
