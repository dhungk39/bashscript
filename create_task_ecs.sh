#!/bin/bash
set -e

TASK_DEFINITION_NAME="ci-hungnd4"
REGION="us-east-1"
CLUSTER_NAME="ecs-hungnd4"

mkdir -p /tmp/workspace
touch /tmp/workspace/echo-output
ls -la /tmp/workspace
echo "Take revision new"
REVISION_NEW=$(aws ecs list-task-definitions --family-prefix "$TASK_DEFINITION_NAME" --status ACTIVE --output json --sort DESC --query taskDefinitionArns[0] | sed 's/"//g')
echo "Run task batch jobs"
aws ecs run-task --cluster "ecs-hungnd4" --count 1 --launch-type "FARGATE" --task-definition "$REVISION_NEW" --network-configuration '{"awsvpcConfiguration": {"subnets":["subnet1","subnet2"], "securityGroups":["sg_id"],"assignPublicIp":"ENABLED"}}' --query tasks[0].taskArn --output text > /tmp/workspace/echo-output
aws ecs list-tasks --cluster ecs-hungnd4
cat /tmp/workspace/echo-output
