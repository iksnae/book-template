FROM ubuntu:22.04

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Set up locale
RUN apt-get update && apt-get install -y locales && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.UTF-8

# Install core dependencies
RUN apt-get update && apt-get install -y \
    software-properties-common \
    apt-transport-https \
    wget \
    curl \
    git \
    zip \
    unzip \
    python3 \
    python3-pip \
    nodejs \
    npm \
    fontconfig \
    imagemagick \
    ghostscript \
    fonts-liberation \
    fonts-noto \
    fonts-noto-cjk \
    fonts-dejavu \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install LaTeX
RUN apt-get update && apt-get install -y \
    texlive-full \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Pandoc (latest version)
RUN wget https://github.com/jgm/pandoc/releases/download/3.1.11/pandoc-3.1.11-1-amd64.deb \
    && dpkg -i pandoc-3.1.11-1-amd64.deb \
    && rm pandoc-3.1.11-1-amd64.deb

# Install Calibre (for EPUB to MOBI conversion)
RUN wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sh /dev/stdin

# Install additional Python packages
RUN pip3 install \
    pyyaml \
    markdown \
    pygments \
    pillow

# Install additional Node.js packages
RUN npm install -g \
    markdown-toc \
    prettier

# Set up work directory
WORKDIR /workspace

# Display versions of key components
RUN echo "Installed versions:" && \
    pandoc --version | head -n 1 && \
    pdflatex --version | head -n 1 && \
    ebook-convert --version | head -n 1 && \
    python3 --version && \
    node --version

# Default command
CMD ["/bin/bash"]