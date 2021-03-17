FROM hashicorp/terraform:light

COPY entrypoint.sh /entrypoint.sh

CMD ["cp", "/github/home/.terraformrc", "/home/root/.terraformrc"]

ENTRYPOINT ["/entrypoint.sh"]
