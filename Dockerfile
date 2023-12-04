FROM python:3.11.2-slim

# Install system packages
RUN apt-get update && \
    apt-get install -y \
        apt-transport-https \
        build-essential \
        cmake \
        curl \
        gcc \
        g++ \
        git \
        libpq-dev \
        python3-dev \
        tree \
        sudo \
        unzip \
        wget \
    && apt-get autoremove -yqq --purge \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Python packages
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir --ignore-installed -r requirements.txt

# Configure default user name and ID
ARG USER_ID="1000"
ENV USER_ID=${USER_ID}
ENV USER_NAME="prefect"

RUN useradd -m ${USER_NAME} -u ${USER_ID} && \
    echo "${USER_NAME}:${USER_NAME}" | chpasswd ${USER_NAME} && \
    echo "${USER_NAME} ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/${USER_NAME} && \
    chmod 0440 /etc/sudoers.d/${USER_NAME} && \
    chown -R ${USER_NAME} /home
USER ${USER_NAME}

# Configure workdir
WORKDIR /home/evidently-monitoring-ui
# Configure PYTHONPATH environment variable
ENV PYTHONPATH=/home/evidently-monitoring-ui
