# Running ModelDB with Kubernetes

Get a modeldb server up and running with Kubernetes on Docker-for-Desktop. 

1. **Install Kubectl**

 https://kubernetes.io/docs/tasks/tools/install-kubectl/
 
2. **Create the Persistent Volume Claim**

To be able to store our data and our models, we need to create a persistent volume claim. 

  ```bash
  cd [path_to_kubernetes_files]
  kubectl apply -f pvc-modeldb.yaml
  ```
We then need to create a dummy pod to upload the files that will store our data in our backend pod. 

  ```bash
  kubectl apply -f pod-modeldb.yaml
  cd ../server/codegen
  kubectl cp db mypod:/thevol
  ```
To check if the files have been added to our dummy pod, we need to check inside the container: 

  ```bash
  kubectl exec -it mypod bash
  ```
Within the container:
  ```bash
  ls -la /thevol/db
 ```
If the `modeldb.db` and `modeldb_test.db` files have been added to our container, then the files have been added to our persistent volume claim and we are good to go! Exit the pod with the `exit` command.

3. **Create the Mongo Server**

We also need to set up our mongo server with kubernetes. 

  ```bash
  cd [path_to_kubernetes_files]
  kubectl apply -f mongo.yaml
  ```
This will create a mongo deployment, service, persistent volume claim and secret. There is also an option to set up mongo authentication for the server 

4. **Create the frontend and backend**

Now that we have the files mounted onto the persistent volume claim, we don't need to dummy pod anymore. We can delete the pod and create our frontend and backend deployments.

  ```bash
  kubectl delete pod mypod
  kubectl create -f [path_to_kubernetes_files]/backend-deployment.yaml
  kubectl create -f [path_to_kubernetes_files]/frontend-deployment.yaml
  ```

We also need kubernetes services for these deployments. This will allow the frontend to be shown on our browser. It also allows our frontend to connect to our backend and the backend to connect to the mongo server. 

  ```bash
  kubectl expose deployment backend --type=LoadBalancer
  kubectl expose deployment frontend --type=LoadBalancer
  ```

`kubectl get all` will allow you to see all your pods, deployments, and services. `kubectl logs [pod_name]` allows you to see what's going on in your pod and can help for troubleshooting.  


