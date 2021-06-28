
FROM jenkins/jenkins:latest
LABEL maintainer ="artkamote@yahoo.com"

USER root

RUN mkdir /var/log/jenkins

RUN chown -R  jenkins:jenkins /var/log/jenkins

ENV JAVA_OPTS="-Xmx8192m"
ENV JENKINS_OPTS=" --handlerCountMax=300"

ARG DOCKER_CLIENT=docker-20.10.7.tgz

# Add build-essential and tools
RUN echo "Acquire::Check-Valid-Until \"false\";\nAcquire::Check-Date \"false\";" | cat > /etc/apt/apt.conf.d/10no--check-valid-until

RUN apt-get update && apt-get install -y --no-install-recommends build-essential \
python3-pip python-pip \
ca-certificates groff less \
bash make jq curl wget g++ \
zip git openssh-server && \
pip --no-cache-dir install awscli && update-ca-certificates && \
cd /tmp/ && \
curl -sSL -O https://download.docker.com/linux/static/stable/x86_64/${DOCKER_CLIENT} && \
tar zxf ${DOCKER_CLIENT} && \
mkdir -p /usr/local/bin && \
mv ./docker/docker /usr/local/bin && \
chmod +x /usr/local/bin/docker && \
rm -rf /tmp/* && \
rm -rf /var/lib/apt/lists/* && \
apt-get clean

WORKDIR /opt/apps
