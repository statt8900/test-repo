#!/usr/bin/env bash

#   Copyright 2022 Modelyst LLC
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

# A script for building and pushing the docker image of the api to ECR
# These variables can change from the defaults if the repo, profile, or region are different
REGION=${REGION:-us-west-2}
PROFILE_NAME=${PROFILE_NAME:-test-repo}
REPO_NAME=${REPO_NAME:-test-repo} # Get the aws account ID for the ecr repo
ACCOUNT_ID=$(aws sts get-caller-identity --profile $PROFILE_NAME | jq -r .Account)
# Login to the repo in docker
aws ecr get-login-password --region $REGION --profile $PROFILE_NAME | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com
# Grab the version of the app for docker tagging
VERSION=$(PYTHONPATH=$PWD/src:$PYTHONPATH  python -c 'from app import __version__; print(__version__)')
# Build the images locally
docker build \
-t $REPO_NAME:$VERSION \
-t $REPO_NAME:latest \
-t $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPO_NAME:$VERSION \
-t $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPO_NAME:latest \
-f ./Dockerfile .
# Push the images to ECR
docker push $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPO_NAME:$VERSION
docker push $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPO_NAME:latest
