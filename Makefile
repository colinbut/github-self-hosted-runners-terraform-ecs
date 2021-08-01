build:
	cd runner_image
	docker build -t github-runner .

run:
	cd runner_image
	docker run -dit --env-file .env.list github-runner /bin/bash