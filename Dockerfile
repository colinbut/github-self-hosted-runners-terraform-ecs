FROM amazonlinux:2

ARG GITHUB_REPO_URL
ARG GITHUB_REPO_PAT_TOKEN
ARG RUNNER_NAME
ARG LABELS

RUN yum update -y && yum install tar gzip shadow-utils libicu -y 
RUN useradd runner_user
USER runner_user

WORKDIR /opt/runner/

RUN curl -o actions-runner-linux-x64-2.278.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.278.0/actions-runner-linux-x64-2.278.0.tar.gz
RUN tar xzf actions-runner-linux-x64-2.278.0.tar.gz
RUN ./config.sh --url $GITHUB_REPO_URL --pat $GITHUB_REPO_PAT_TOKEN --name ${RUNNER_NAME} --work _work --labels ${LABELS} --runasservice

# start the github runner as a service on startup
RUN ./svc.sh install
RUN ./svc.sh start

CMD [ "tail", "-f", "/dev/null" ]