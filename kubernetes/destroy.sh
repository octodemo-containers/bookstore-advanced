#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Web App
kubectl delete -f $DIR/bookstore-service.yml
kubectl delete -f $DIR/bookstore-deployment.yml
kubectl delete -f $DIR/bookstore-configmap.yml

# Database
kubectl delete -f $DIR/database-service.yml
kubectl delete -f $DIR/database-deployment.yml
kubectl delete -f $DIR/database-volume.yml

# Secrets
kubectl delete -f $DIR/secrets.yml

gcloud compute disks delete bookstore-db-data-disk --zone europe-west2-a