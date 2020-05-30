#!/bin/bash

set -eu

set -o pipefail

_CURR_DIR="$( cd "$(dirname "$0")" ; pwd -P )"

docker run -t -u `id -u` -v ${_CURR_DIR}/artifacts:/runner/artifacts:Z \
 -v ${_CURR_DIR}/out:/runner/out:Z \
 -v ${_CURR_DIR}/env:/runner/env:Z \
 -v ${_CURR_DIR}/inventory:/runner/inventory:Z \
 -v ${_CURR_DIR}/project:/runner/project:Z \
 -e PROJECT_DIR=${_CURR_DIR}/project \
 -e RUNNER_PLAYBOOK=generate-spoke-resources.yaml \
 ansible/ansible-runner:latest
