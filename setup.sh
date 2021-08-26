#!/bin/bash
set -e

curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.22.0/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv kubectl /usr/local/bin/kubectl
exit

curl -Lo kops https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
chmod +x kops
sudo mv kops /usr/local/bin/kops

aws s3api create-bucket \
    --bucket kops-martinowitsch-state \
    --create-bucket-configuration LocationConstraint=eu-west-1 \
    --region eu-west-1

aws s3api put-bucket-versioning --bucket kops-martinowitsch-state \
    --versioning-configuration Status=Enabled

aws s3api put-bucket-encryption --bucket kops-martinowitsch-state \
    --server-side-encryption-configuration '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}'

export NAME=myfirstcluster.example.com

# ./kops.sh edit cluster martinowitsch.net
# ./kops.sh edit ig --name=martinowitsch.net master-eu-west-1a
# ./kops.sh edit ig --name=martinowitsch.net nodes-eu-west-1a
