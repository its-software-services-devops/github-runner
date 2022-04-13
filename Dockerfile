FROM google/cloud-sdk:381.0.0
ARG VERSION
ARG HELM_PLUGINS_PATH=/helm/plugins

RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
RUN chmod 700 get_helm.sh
RUN ./get_helm.sh

RUN helm version
RUN export HELM_PLUGINS=${HELM_PLUGINS_PATH} && mkdir -p ${HELM_PLUGINS} && helm plugin install https://github.com/hayorov/helm-gcs.git

RUN gcloud version

RUN curl -L -o jsonnet.tar.gz https://github.com/google/jsonnet/releases/download/v0.17.0/jsonnet-bin-v0.17.0-linux.tar.gz
RUN tar -xvf jsonnet.tar.gz; cp jsonnet jsonnetfmt /usr/bin/
RUN jsonnet --version

COPY scripts/* /usr/bin/
COPY utils/* /usr/bin/
RUN chmod -R 555 /usr/bin/*.bash /usr/bin/*.pl

RUN mkdir -p /data
RUN echo ${VERSION} > /data/version.txt

ENV GOOGLE_APPLICATION_CREDENTIALS=/gcloud/secret/key.json
ENV SYSTEM_STATE_FILE=states.txt
ENV HELM_PLUGINS=${HELM_PLUGINS_PATH}
