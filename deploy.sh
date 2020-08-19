#!/bin/sh

kubectl apply -f pvc.yaml
helm install jenkins stable/jenkins --set rbac.create=true,master.servicePort=80,master.serviceType=LoadBalancer,persistence.existingClaim=jenkins-pvc

