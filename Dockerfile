FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# 1) Install dependencies for LibreDWG + Python + build tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      build-essential git autoconf automake libtool pkg-config \
      python3 python3-pip ca-certificates curl \
      zlib1g-dev libpng-dev libcairo2-dev && \
    rm -rf /var/lib/apt/lists/*

# 2) Build LibreDWG from source (provides dwg2svg)
WORKDIR /tmp
RUN git clone --depth 1 https://github.com/LibreDWG/libredwg.git && \
    cd libredwg && \
    ./autogen.sh && \
    ./configure --disable-static --enable-shared && \
    make -j"$(nproc)" && \
    make install && \
    ldconfig

# 3) Confirm dwg2svg installed
RUN which dwg2svg && dwg2svg --help >/dev/null 2>&1

# 4) Copy your Flask app
WORKDIR /app
COPY server.py /app/server.py
RUN pip3 install --no-cache-dir flask

EXPOSE 8080
ENV PORT=8080

# 5) Run the converter
CMD ["python3", "server.py"]
