#!/bin/bash

#ansible-playbook -i inventory/mycluster/inventory.ini --become --become-user=root cluster.yml -b -v --private-key=~/.ssh/gcloud -u ubuntu -e kube_version=v1.18.5

ansible-playbook -i inventory/mycluster/inventory.ini --become --become-user=root upgrade-cluster.yml -v --private-key=~/.ssh/gcloud -u ubuntu -e kube_version=v1.19.2

