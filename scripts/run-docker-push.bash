#!/bin/bash

PROJECT_IMAGE=$1
CONTEXT_PATH=$2

echo "#### show PROJECT_IMAGE ${1} of env1 ####"
echo "#### show CONTEXT_PATH ${2} of env2 ####"
echo "#### Running the ${0} script ####"

echo "GITHUB_REF=[${GITHUB_REF}]"
echo "GIT_HASH=[${GIT_HASH}]"

DOCKER_TAG_LATEST=latest

if [[ $GITHUB_REF == refs/tags/* ]]; then
    DOCKER_TAG=${GITHUB_REF#refs/tags/}
elif [[ $GITHUB_REF == refs/heads/* ]]; then
    BRANCH=$(echo ${GITHUB_REF#refs/heads/} | sed -r 's#/+#-#g')

    DOCKER_TAG_LATEST=${BRANCH}-latest
    DOCKER_TAG=$GIT_HASH
fi

DOCKER_FILE_PATH=""
if [ "${DOCKER_FILE}" != '' ]; then
    DOCKER_FILE_PATH="-f ${DOCKER_FILE}"
fi

docker build -t ${PROJECT_IMAGE}:${DOCKER_TAG} -t ${PROJECT_IMAGE}:${DOCKER_TAG_LATEST} ${CONTEXT_PATH} ${DOCKER_FILE_PATH}
retVal=$?
if [ $retVal -ne 0 ]; then
    exit 1
fi

docker push ${PROJECT_IMAGE}:${DOCKER_TAG}
retVal=$?
if [ $retVal -ne 0 ]; then
    exit 1
fi

docker push ${PROJECT_IMAGE}:${DOCKER_TAG_LATEST}
retVal=$?
if [ $retVal -ne 0 ]; then
    exit 1
fi

echo "SYSTEM_DOCKER_IMAGE_TAG=${DOCKER_TAG}" >> ${SYSTEM_STATE_FILE}
