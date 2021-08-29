#!/bin/bash
set -ex

kubectl taint nodes --all node-role.kubernetes.io/master-
