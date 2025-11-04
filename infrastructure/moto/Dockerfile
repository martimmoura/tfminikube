FROM python:3.11-slim
RUN pip3 install moto[proxy]
ENTRYPOINT ["moto_proxy", "-H", "0.0.0.0"]
EXPOSE 5005
