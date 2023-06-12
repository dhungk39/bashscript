#!/bin/bash
set -e

echo "Install jq"
sudo apt install jq -y

TASK_DEFINITION_NAME="ci-hungnd4"
REPO_NAME=circleci-ecr-demo
REGION="us-east-1"
CLUSTER_NAME="ecs-hungnd4"

echo "Take repo URL"
REPO_URL=$(echo $(aws ecr describe-repositories --repository-name "$REPO_NAME" --query repositories[0].repositoryUri) | sed 's/"//g' )
echo "Take image tag"
IMAGE_TAG=$(aws ecr describe-images --repository-name "$REPO_NAME" --query 'sort_by(imageDetails,& imagePushedAt)[-1].imageTags[0]' | sed 's/"//g')
echo "Image URL"
IMAGR_URL=$REPO_URL:$IMAGE_TAG
echo "Take revision of task definition"
REVISION_OLD=$(aws ecs list-task-definitions --family-prefix "$TASK_DEFINITION_NAME" --status ACTIVE --output json --sort DESC --query taskDefinitionArns[0] | sed 's/"//g')
echo "Take json revision of task definition"
TASK_DEFINITION_REVISION=$(aws ecs describe-task-definition --task-definition "$REVISION_OLD")
echo "Create new revision task definition"
NEW_TASK_DEFINTIION=$(echo $TASK_DEFINITION_REVISION | jq --arg IMAGE "$IMAGR_URL" '.taskDefinition | .containerDefinitions[0].image = $IMAGE | del(.taskDefinitionArn) | del(.revision) | del(.status) | del(.requiresAttributes) | del(.compatibilities) | del(.registeredAt) | del(.registeredBy)')
aws ecs register-task-definition --region "$REGION" --cli-input-json "$NEW_TASK_DEFINTIION" > /dev/null
echo "Create revision task definition finish"
