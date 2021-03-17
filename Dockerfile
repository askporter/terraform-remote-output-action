FROM hashicorp/terraform:light

COPY entrypoint.sh ./entrypoint.sh

CMD terraform init

ENTRYPOINT ["./entrypoint.sh"]
