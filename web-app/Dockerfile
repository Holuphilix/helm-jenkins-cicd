# Use official Docker image as base, with Docker CLI
FROM docker:24.0.5-dind

# Install bash, curl, unzip, and other dependencies
RUN apk add --no-cache bash curl unzip python3 py3-pip

# Install AWS CLI v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip" && \
    unzip /tmp/awscliv2.zip -d /tmp && \
    /tmp/aws/install && \
    rm -rf /tmp/awscliv2.zip /tmp/aws

# Install Helm (version 3.14.2 here, change if needed)
RUN curl -fsSL https://get.helm.sh/helm-v3.14.2-linux-amd64.tar.gz | tar -xz -C /tmp && \
    mv /tmp/linux-amd64/helm /usr/local/bin/helm && \
    chmod +x /usr/local/bin/helm && \
    rm -rf /tmp/linux-amd64

# Use bash as default shell
CMD ["bash"]
