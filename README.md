# stable-diffusion-webui-docker

**Stable Diffusion WebUI** running either locally (CPU or GPU) or behind a Nginx reverse proxy with Let's Encrypt (ideal for installing on a headless GPU server).

It installs Stable Diffusion WebUI with xformers enabled. The default model installed is Stable Diffusion 1.5. The initial build is quite long (4-5 minutes) even on a powerful server. Subsequent launch will take a few seconds.

It's up to you to install additional models, LoRa, VAE, etc.

## Running locally (CPU only)

After cloning the repository, run:

    # Initial download of models (run once)
    $ docker compose --profile download up --build

    # Start WebUI
    $ docker compose --profile local-cpu up --build

Access from http://localhost:7860/

## Running locally (GPU-enabled)

Ensure your system has NVIDIA Docker Toolkit installed and configured for Docker to access the GPU.

After cloning the repository, run:

    # Initial download of models (run once)
    $ docker compose --profile download up --build

    # Start WebUI with GPU support
    $ docker compose --profile local-gpu up --build

Access from http://localhost:7860/

## Running in the cloud (GPU server)

After cloning the repository, create `.env` file and customize with your own domain and email:

```
VIRTUAL_HOST=sd.yourdomain.com
VIRTUAL_PORT=7860
LETSENCRYPT_HOST=sd.yourdomain.com
LETSENCRYPT_EMAIL=username@yourdomain.com
```

Before proceeding, ensure that your DNS settings are correctly configured to point your domain (e.g., sd.yourdomain.com) to the IP address of your cloud server. This step is crucial for Let's Encrypt to verify your domain and issue a SSL certificate.

Create `.htpasswd` file to setup HTTP basic auth to protect the Web UI:

    $ htpasswd -c .htpasswd username

You may need to install apache2-utils package:

    $ sudo apt-get install apache2-utils

You are ready to build & launch:

    # Initial download of models (run once)
    $ docker compose --profile download up --build

    # Start WebUI in detached mode (-d)
    $ docker compose --profile cloud up -d --build

The initial build is quite long (4-5 minutes) even on a powerful server. Subsequent launch will take a few seconds.

The WebUI will be available at https://sd.yourdomain.com (as defined in your `.env` file).

If you have any issue, you can check the logs:

    $ docker compose logs -tf

## Persistent Storage

### Data Volume

All persistent data including models, extensions, and settings are stored in a Docker volume named `data`. This ensures your configurations and installed components persist across container restarts and updates.

### Local Output Directory

Generated content (images, etc.) is stored in a local `outputs` directory, which is mapped to the container. This makes it easy to access and manage your generated content from your host system.

## Notes

Compatibility matrix for PyTorch

    https://github.com/pytorch/pytorch/wiki/PyTorch-Versions

## Credits

Thanks to:

- [Stability.ai](https://stability.ai/) for the fairly open image diffusion model
- [AUTOMATIC1111](https://github.com/AUTOMATIC1111/stable-diffusion-webui) for the WebUI
- [AbdBarho](https://github.com/AbdBarho/stable-diffusion-webui-docker/) for the download container idea
- and the huge SD community for all the tutorials and models!
