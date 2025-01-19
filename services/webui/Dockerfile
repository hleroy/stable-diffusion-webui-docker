FROM pytorch/pytorch:2.3.1-cuda12.1-cudnn8-runtime
ENV DEBIAN_FRONTEND=noninteractive PIP_PREFER_BINARY=1

# Install necessary packages
RUN --mount=type=cache,target=/var/cache/apt \
    apt update -y && apt upgrade -y && \
    apt install -y wget git python3 python3-pip libgl1 libglib2.0-0 libtcmalloc-minimal4

# Clone latest Stable Diffusion Web UI (dev branch) from its official repository and install requirements
RUN --mount=type=cache,target=/root/.cache/pip \
    git clone --depth 1 -b dev https://github.com/AUTOMATIC1111/stable-diffusion-webui.git && \
    cd stable-diffusion-webui && \
    pip install -r requirements.txt

# Install xformers
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install xformers==0.0.27

# Setup our working directory
ENV ROOT=/workspace/stable-diffusion-webui
WORKDIR ${ROOT}

# Setup WebUI environment
ENV TORCH_COMMAND="echo 'Skipping torch install'"
RUN python3 -u launch.py --skip-torch-cuda-test --exit

# Additional requirements for common extensions
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install rich fake_useragent send2trash ultralytics onnx onnx_graphsurgeon polygraphy dynamicprompts optimum \
    colorama basicsr simplejson wget clip_interrogator slugify mediapipe controlnet_aux open-clip-torch==2.24.0 \
    ZipUnicode

ENV NVIDIA_VISIBLE_DEVICES=all
ENV CLI_ARGS=""
ENV CUDA_HOME=/usr/local/cuda

EXPOSE 7860

# Copy entrypoint.sh into the container
COPY entrypoint.sh /docker/entrypoint.sh
RUN chmod +x /docker/entrypoint.sh
ENTRYPOINT ["/docker/entrypoint.sh"]

# Run WebUI
CMD ["python3", "-u", "webui.py", "--skip-install", "--listen", "--port", "7860"]
