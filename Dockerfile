FROM hashicorp/terraform:light

# External
ENV TF_VAR_access_key "MY_AWS_ACCESS_KEY"
ENV TF_VAR_secret_key "MY_AWS_SECRET_KEY"
ENV TF_VAR_region "us-east-1"
ENV TF_VAR_terraform_directory "/infrastructure_provisioning/"

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["--help"]
