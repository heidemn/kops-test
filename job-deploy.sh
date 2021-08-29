#!/bin/bash
set -x

kubectl delete -f job-succeeds.yml
kubectl apply -f job-succeeds.yml

if ! kubectl wait --for=condition=complete --timeout=20s job/myjob-succeeds; then
    echo "Job FAILED!"
fi
kubectl logs job/myjob-succeeds

echo
echo

kubectl delete -f job-fails.yml
kubectl apply -f job-fails.yml

if ! kubectl wait --for=condition=complete --timeout=20s job/myjob-fails; then
    echo "Job FAILED!"
fi
kubectl logs job/myjob-fails
