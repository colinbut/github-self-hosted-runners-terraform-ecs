FROM amazonlinux:2

ENV GITHUB_REPO_URL=""
ENV GITHUB_REPO_PAT_TOKEN=""
ENV RUNNER_NAME="github-repo-runner"
ENV LABELS=""

RUN yum update -y && \
    yum install sudo tar gzip shadow-utils libicu util-linux -y && \
    useradd runner_user

USER runner_user

WORKDIR /opt/runner/

COPY download.sh start.sh runner-service.sh /opt/runner/
USER root
RUN chmod +x download.sh start.sh runner-service.sh && \
    chown runner_user:runner_user download.sh start.sh runner-service.sh

USER runner_user
# TODO fix disable root user password when sudo
CMD ["sh", "-c", "./download.sh; ./start.sh; sudo ./runner-service.sh"]
#CMD [ "tail", "-f", "/dev/null" ]