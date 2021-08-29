#!/bin/bash
set -e

exit


curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.22.0/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv kubectl /usr/local/bin/kubectl

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

./kops.sh edit cluster martinowitsch.net
./kops.sh edit ig --name=martinowitsch.net master-eu-west-1a
./kops.sh edit ig --name=martinowitsch.net nodes-eu-west-1a

# Do stuff

# Scale down to 0

# Scale up again
# Wait until DNS is updated (can take 5min)

# ./kops.sh export kubecfg --admin
# kubectl taint nodes --all node-role.kubernetes.io/master-
