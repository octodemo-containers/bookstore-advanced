#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Persistent Volume for containers
gcloud compute disks create bookstore-db-data-disk --size 10GB --zone europe-west2-a

# Secrets
kubectl create -f $DIR/secrets.yml

# Database
kubectl create -f $DIR/database-volume.yml
kubectl create -f $DIR/database-deployment.yml
kubectl create -f $DIR/database-service.yml

# Web App
kubectl create -f $DIR/bookstore-configmap.yml
kubectl create -f $DIR/bookstore-deployment.yml
kubectl create -f $DIR/bookstore-service.yml
