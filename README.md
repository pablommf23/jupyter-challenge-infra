# jupyter-challenge-infra

This repository has all infrastructure needed to run a dockerized application under 50000 request during 45 seconds.In order to address that kind of load in a secure manner, Kubernetes solution were chosen.

# IaC

Infrastructure as code is based on Google's public Terraform modules and following Standard Folder Structure. 

Terraform State files for both environments are stored under the same manually created bucket (encrypted)


# Environment and Gitflow

2 environments were deployed: development and production. Each environment has its on Private GKE Cluster


Gitflow adopted to comply with idempotency allows ONLY APPLY or PLAN to a single environment pushing to a single branch:

infra-plan->develop->main

# Access control

Credentials created using JSON key on manually deployed service account  "cicd-github-actions@latam-challenge.iam.gserviceaccount.com"

GKE Service account uses the same as the pipeline (time constrain)

# Performance and Architecture


Node pool calculation were made based on CPU-optimized c2-standard-4 worker node instances and FastAPI backend estimating 1000 request/seconds per pod, so maximum load should be served with at least 3 nodes and 3 pods per node deployment.

