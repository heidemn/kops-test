#!/bin/bash
set -e

# Because "aws configure" doesn't export these vars for kops to use, we export them now
export AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id)
export AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key)

export KOPS_STATE_STORE=s3://kops-martinowitsch-state

export NAME=martinowitsch.net

#kops create cluster \
#    --zones=eu-west-1a \
#    ${NAME}

kops "$@"
