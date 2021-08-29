#!/bin/bash
set -ex

master_ip="$(aws ec2 describe-instances \
    --filters "Name=tag:Name,Values=master-eu-west-1a.masters.martinowitsch.net" \
    --query "Reservations[*].Instances[*].PublicIpAddress" \
    --output text)"


cat << EOF > /tmp/route53-record.json
{
    "Comment": "CREATE/DELETE/UPSERT a record ",
    "Changes": [{
        "Action": "UPSERT",
        "ResourceRecordSet": {
            "Name": "api.martinowitsch.net",
            "Type": "A",
            "TTL": 60,
            "ResourceRecords": [{ "Value": "$master_ip"}]
        }
    }]
}
EOF

cat /tmp/route53-record.json


zone_id="$(\
    aws route53 list-hosted-zones-by-name \
        --dns-name martinowitsch.net. \
        --query "HostedZones[*].Id" \
        --output text \
    | sed 's#/hostedzone/##')"

aws route53 change-resource-record-sets \
    --hosted-zone-id "$zone_id" \
    --change-batch file:///tmp/route53-record.json
