FROM summerwind/actions-runner:v2.289.1-ubuntu-20.04

USER root

RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
RUN chmod 700 get_helm.sh
RUN ./get_helm.sh

RUN helm version

RUN helm plugin install https://github.com/hayorov/helm-gcs.git

RUN apt-get update && \
    apt-get install -y curl gnupg && \
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && \
    apt-get update -y && \
    apt-get install google-cloud-sdk -y
RUN gcloud version

RUN curl -L -o jsonnet.tar.gz https://github.com/google/jsonnet/releases/download/v0.17.0/jsonnet-bin-v0.17.0-linux.tar.gz
RUN tar -xvf jsonnet.tar.gz; cp jsonnet jsonnetfmt /usr/bin/
RUN jsonnet --version

COPY scripts/* /scripts/
RUN chmod -R 555 /scripts/*

COPY utils/* /utils/
RUN chmod -R 555 /utils/*

ENV PATH="/utils:/scripts:${PATH}"
ENV GOOGLE_APPLICATION_CREDENTIALS=/gcloud/secret/key.json
ENV SYSTEM_STATE_FILE=states.txt

RUN chown runner:runner -R /home/runner/.config
RUN chown runner:runner -R /home/runner/.cache

USER runner
