#!/bin/bash
set -e

run_cmd() {
    echo "$@" >&2
    "$@"
}

# Scale masters, e.g. switch between 0 and 1:
run_cmd ./kops.sh edit ig master-eu-west-1a

# Scale nodes (always 0 for me):
# ./kops.sh edit ig --name=martinowitsch.net nodes-eu-west-1a

echo
my_ip="$(curl --silent https://ipv4.icanhazip.com/)"
echo "YOUR IPv4: $my_ip"
if command -v clip.exe > /dev/null; then
    echo -n "$my_ip/32" | clip.exe
    echo "Copied to Windows clipboard!"
fi
echo "Press <RETURN> to edit cluster..."
read

run_cmd ./kops.sh edit cluster

run_cmd ./kops.sh update cluster --yes

run_cmd ./kops.sh export kubecfg --admin

# Fix delayed Route53 update:
run_cmd ./route53-update.sh

# Once kubectl works:
# ./untaint-masters.sh
