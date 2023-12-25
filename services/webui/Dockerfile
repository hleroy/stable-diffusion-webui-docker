FROM pytorch/pytorch:2.1.2-cuda12.1-cudnn8-runtime
ENV DEBIAN_FRONTEND noninteractive PIP_PREFER_BINARY=1

# Install necessary packages
RUN --mount=type=cache,target=/var/cache/apt \
    apt update -y && apt upgrade -y && \
    apt install -y wget git python3 python3-pip libgl1 libglib2.0-0 sudo

# Clone Stable Diffusion Web UI from its official repository and install requirements
RUN --mount=type=cache,target=/root/.cache/pip \
    git clone -b v1.7.0 https://github.com/AUTOMATIC1111/stable-diffusion-webui.git && \
    cd stable-diffusion-webui && \
    pip install -r requirements_versions.txt

# Install xformers
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install xformers==0.0.23.post1

# Additional requirements for common extensions
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install rich fake_useragent send2trash

# Setup our working directory
ENV ROOT=/workspace/stable-diffusion-webui
WORKDIR ${ROOT}

# Setup WebUI environment
RUN python3 -u launch.py --skip-torch-cuda-test --exit

ENV NVIDIA_VISIBLE_DEVICES=all
ENV CLI_ARGS=""

EXPOSE 7860

# Copy entrypoint.sh into the container
COPY entrypoint.sh /docker/entrypoint.sh
RUN chmod +x /docker/entrypoint.sh
ENTRYPOINT ["/docker/entrypoint.sh"]

# Run WebUI
CMD python3 -u webui.py --skip-install --listen --port 7860 ${CLI_ARGS}
