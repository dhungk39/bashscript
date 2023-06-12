#!/bin/bash
set -e

CLUSTER_NAME="ecs-hungnd4"
cat /tmp/workspace/echo-output
TASKARN=$(cat /tmp/workspace/echo-output)
echo "delete task batch jobs"
aws ecs stop-task --cluster "$CLUSTER_NAME" --task "$TASKARN"
