#!/bin/bash

set -eu

set -o pipefail

_CURR_DIR="$( cd "$(dirname "$0")" ; pwd -P )"

if [ ! -f ${_CURR_DIR}/project/out/.kubeconfig ];
then
   echo "$(kind get kubeconfig --name=spoke-pipelines)" \
    | tee ${_CURR_DIR}/project/out/.kubeconfig
fi

docker run -t -u `id -u` --net kind \
 -v ${_CURR_DIR}/project/artifacts:/runner/artifacts:Z \
 -v ${_CURR_DIR}/project/out:/runner/out:Z \
 -v ${_CURR_DIR}/env:/runner/env:Z \
 -v ${_CURR_DIR}/inventory:/runner/inventory:Z \
 -v ${_CURR_DIR}/project:/runner/project:Z \
 -e PROJECT_DIR=${_CURR_DIR}/project \
 -e RUNNER_PLAYBOOK=generate-spoke-resources.yaml \
 -e KUBECONFIG=/runner/project/out/.kubeconfig \
   quay.io/kameshsampath/ansible-runner:latest
