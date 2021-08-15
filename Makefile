init:
	cd terraform && \
		terraform init

plan:
	cd terraform && \
		terraform plan

apply:
	cd terraform && \
		terraform apply

destroy:
	cd terraform && \
		terraform destroy
