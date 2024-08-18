#! /usr/bin/env bash

[[ $TRACE ]] && set -x
set -euo pipefail

readonly proj_version=$1

aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws
docker build -t python-docker .
docker tag python-docker:latest public.ecr.aws/t9d0k4q5/python:${proj_version}
docker push public.ecr.aws/t9d0k4q5/python:${proj_version}
