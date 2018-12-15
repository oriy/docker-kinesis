FROM ubuntu:14.04

RUN apt-get update --upgrade
RUN apt-get install -y curl
RUN curl -sL https://deb.nodesource.com/setup_4.x | sudo bash -
RUN apt-get install -y nodejs build-essential
RUN apt-get install -y git-core --fix-missing

RUN npm install -g kinesalite

RUN npm install -g dynalite

RUN apt-get -y install python-pip
RUN pip install awscli

ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY
ARG AWS_DEFAULT_REGION

ENV AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
ENV AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
ENV AWS_REGION=${AWS_DEFAULT_REGION}
ENV AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}

RUN aws --version

COPY entrypoint.sh /entrypoint.sh
COPY init_streams.sh /init_streams.sh
COPY create_stream.sh /create_stream.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["--ssl --port 443"]
EXPOSE 443
EXPOSE 4568
