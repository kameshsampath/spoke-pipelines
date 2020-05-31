#!/bin/bash

set -eu

set -o pipefail

docker build -t quay.io/kameshsampath/ansible-runner .

docker push quay.io/kameshsampath/ansible-runner