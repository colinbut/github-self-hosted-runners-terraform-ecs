docker-login:
	aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin $(AWS_ACCOUNT_ID).dkr.ecr.eu-west-1.amazonaws.com

build:
	cd runner_image && \
		docker build -t $(AWS_ACCOUNT_ID).dkr.ecr.eu-west-1.amazonaws.com/github-runner .

run:
	cd runner_image && \
		docker run -dit --env-file .env.list github-runner /bin/bash

push:
	cd runner_image && \
		docker push $(AWS_ACCOUNT_ID).dkr.ecr.eu-west-1.amazonaws.com/github-runner
