FROM debian:stable
RUN apt-get update && \
    apt-get -y install nginx-light && \
    rm -rf /var/lib/apt/lists/*
    
EXPOSE 80

USER root 

CMD /bin/sh
