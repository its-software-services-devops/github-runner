#!/bin/bash

GCR=asia.gcr.io
GAR=asia-southeast1-docker.pkg.dev
VERSION=$(cat /data/version.txt)
KEYFILE_DIR=$(dirname ${GOOGLE_APPLICATION_CREDENTIALS})

echo "#### Running the ${0} script, docker version [${VERSION}] ####"

JSON=${GOOGLE_APPLICATION_CREDENTIALS_JSON} #Injected by Github Secret
if [ "${JSON}" != '' ]; then
    mkdir -p ${KEYFILE_DIR}
    echo "${JSON}" | base64 -d > ${GOOGLE_APPLICATION_CREDENTIALS}
fi

gcloud auth activate-service-account --key-file=${GOOGLE_APPLICATION_CREDENTIALS}
gcloud auth print-access-token | docker login -u oauth2accesstoken --password-stdin ${GCR}
gcloud auth print-access-token | docker login -u oauth2accesstoken --password-stdin ${GAR}

git config --global user.email "devops-cicd@everapp.io"
git config --global user.name "devops-cicd"
