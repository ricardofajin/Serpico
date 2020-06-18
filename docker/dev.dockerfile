FROM ruby:2.4.0
MAINTAINER Ricardo Fajin
ENV SRP_ROOT /Serpico
WORKDIR $SRP_ROOT
RUN apt update; apt install -y vim git
RUN git clone https://github.com/ricardofajin/Serpico.git --branch ricardofajin-patch-1 ; mv Serpico/* . ; rm -r Serpico
RUN bundle install
EXPOSE 8443
CMD ["bash", "docker/docker.sh"]
