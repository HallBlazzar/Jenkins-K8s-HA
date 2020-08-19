#!/bin/sh

kubectl apply -f pvc.yaml
helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm install jenkins stable/jenkins --set rbac.create=true,master.servicePort=80,master.serviceType=NodePort,persistence.existingClaim=jenkins-pvc

