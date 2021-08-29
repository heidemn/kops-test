#!/bin/bash
set -ex

./kops.sh edit ig master-eu-west-1a

./kops.sh update cluster --yes

./kops.sh export kubecfg --admin

# Fix delayed Route53 update
./route53-update.sh

# Once kubectl works:
# ./untaint-masters.sh
