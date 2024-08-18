FROM public.ecr.aws/amazonlinux/amazonlinux:2

# YUM Update
RUN yum update -y -q && yum -y -q groupinstall "Development Tools" 

# Install Python, Others installs and Pip
RUN yum -y -q install epel yum-utils openssl11-1.1.1g openssl11-libs-1.1.1g openssl11-devel-1.1.1g bzip2-devel libffi-devel wget curl unzip libgomp gcc.x86_64 gcc-c++.x86_64 && \
    wget -q https://www.python.org/ftp/python/3.11.9/Python-3.11.9.tgz && \
    tar xf Python-3.11.9.tgz && cd Python-3.11*/ && ./configure --enable-optimizations &> /dev/null && make -s altinstall &> /dev/null && \
    ln -sf /usr/local/bin/python3.11 /usr/local/bin/python3 

RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3.11

RUN update-alternatives --install /usr/bin/pip pip /usr/local/bin/pip3.11 1

RUN pip install numpy 

# Install Java 8 AWS CLIv2
RUN wget -q https://corretto.aws/downloads/latest/amazon-corretto-8-x64-linux-jdk.rpm && \
    yum localinstall -y amazon-corretto-8-x64-linux-jdk.rpm && \
    rm -f amazon-corretto-8-x64-linux-jdk.rpm && \
    wget -q https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip && \
    unzip -qq awscli-exe-linux-x86_64.zip && \
    ./aws/install && rm -f awscli-exe-linux-x86_64.zip 

# Cleanup
RUN yum remove -y wget && yum autoremove -y && yum clean all