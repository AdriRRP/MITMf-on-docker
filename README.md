# MITMf-on-docker

**MITMf-on-docker** is a Dockerized version of the **MITMf (Man-in-the-Middle Framework)**. This project simplifies running MITMf by bypassing compatibility issues related to Python 2.7, allowing for easier setup and execution in an isolated containerized environment.

This Docker setup automates the installation of dependencies and ensures MITMf runs smoothly without the need for manual configuration, making it easier to use for penetration testing and other security assessments.

## Prerequisites

To build and run this Docker image, you need to have **Docker** installed on your system.

- **Docker**: You can follow the installation instructions for Docker on their [official website](https://docs.docker.com/get-docker/).

## How to Build and Run

### 1. Clone the repository

```bash
git clone https://github.com/your-username/MITMf-on-docker.git
cd MITMf-on-docker
```

### 2. Build the Docker image

Run the following command to build the Docker image. This will create a Docker image named `mitmf-docker` based on the `Dockerfile` in the current directory.

```bash
sudo docker build -t mitmf-docker .
```

### 3. Run MITMf with the provided script `mitmf.sh`

Once the image is built, you can use the included `mitmf.sh` script to run MITMf inside the Docker container. The script handles the execution of the container and passes the necessary arguments.

Run the following command as example to start MITMf arp spoofing:

```bash
sudo ./mitmf.sh -i eth0 --spoof --arp --gateway 192.168.65.1
```

### 4. Customization

You can modify the `mitmf.sh` script to pass any desired arguments to MITMf, or run the container manually with Docker commands. The script provides an easy way to invoke MITMf with the correct configurations without worrying about dependencies.

## MITMf Project Reference

This project is based on the original [MITMf project](https://github.com/byt3bl33d3r/MITMf) by [byt3bl33d3r](https://github.com/byt3bl33d3r). You can find more information about MITMf in the original repository.
