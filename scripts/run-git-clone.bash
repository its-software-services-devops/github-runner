#!/bin/bash

echo "#### Running the ${0} script ####"

CLONE_SSH_URI=$1
TO_FOLDER=$2

URL=https://${GITHUB_TOKEN}:x-oauth-basic@github.com/${CLONE_SSH_URI}
git clone ${URL} ${TO_FOLDER}
