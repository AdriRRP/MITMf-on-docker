FROM debian:stretch-slim

# Configure archived Debian repositories
RUN sed -i 's|http://deb.debian.org/debian|http://archive.debian.org/debian|' /etc/apt/sources.list && \
    sed -i '/stretch-updates/d' /etc/apt/sources.list && \
    sed -i 's|http://security.debian.org/debian-security|http://archive.debian.org/debian-security|' /etc/apt/sources.list && \
    echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99no-check-valid-until && \
    apt-get update && apt-get install -y \
    python2.7 \
    python2.7-dev \
    python-pip \
    python-setuptools \
    python-twisted \
    libpcap0.8-dev \
    libnetfilter-queue-dev \
    libssl-dev \
    libjpeg-dev \
    libxml2-dev \
    libxslt1-dev \
    libcapstone-dev \
    libffi-dev \
    zlib1g-dev \
    file \
    gcc \
    git \
    make \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set python2 as the default command
RUN [ -e /usr/bin/python ] || ln -s /usr/bin/python2.7 /usr/bin/python

# Clone the MITMf repository
RUN git clone https://github.com/byt3bl33d3r/MITMf /opt/MITMf
WORKDIR /opt/MITMf
RUN git submodule init && git submodule update --recursive

# Replace the line in requirements.txt to use the v0.9.0 tag of the correct repository
RUN sed -i 's|git+https://github.com/kti/python-netfilterqueue|https://github.com/oremanj/python-netfilterqueue/archive/refs/tags/v0.9.0.tar.gz#egg=netfilterqueue|' requirements.txt

# Exclude Twisted from requirements.txt (it is installed previously with apt)
RUN sed -i '/Twisted/d' requirements.txt

# Install Python dependencies
RUN python -m pip install --upgrade pip incremental
RUN python -m pip install cython

# Install remaining dependencies from requirements.txt
RUN pip install -r requirements.txt

# Set entrypoint to run mitmf.py
ENTRYPOINT ["python", "mitmf.py"]

# Set CMD to provide default arguments if none are passed
CMD []
