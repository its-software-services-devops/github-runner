#!/bin/bash

echo "#### Running the ${0} script ####"

CLONE_SSH_URI=$1
TO_FOLDER=$2

#URL=https://gitlab-ci-token:${GITLAB_TOKEN}@gitlab.com/ever-medical-technologies/${CLONE_SSH_URI}

GITHUB_TOKEN=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
URL=https://${GITHUB_TOKEN}:x-oauth-basic@github.com/${CLONE_SSH_URI}
git clone ${URL} ${TO_FOLDER}
