#!/bin/bash

# TODO : Added arguments validation here

CHART_PATH=$1
CHART_NAME=$2

echo "#### Running the ${0} script ####"

GCS_PATH=gs://evermed-devops-helm-charts/${CHART_NAME}

helm gcs init ${GCS_PATH}
helm dependencies update
helm repo add ${CHART_PATH} ${GCS_PATH}

helm package ${CHART_PATH} #--version="${VERSION}"

PKG_FILE=$(ls ${CHART_PATH}/helm*.tgz)
helm gcs push ${PKG_FILE} ${CHART_PATH} --force
