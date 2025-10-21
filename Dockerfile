FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# 1. Install all build dependencies for LibreDWG
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      build-essential git autoconf automake libtool pkg-config \
      flex bison gperf gettext help2man texinfo \
      python3 python3-pip ca-certificates curl \
      zlib1g-dev libpng-dev libcairo2-dev libpango1.0-dev libxml2-dev \
      libfreetype6-dev libfontconfig1-dev && \
    rm -rf /var/lib/apt/lists/*

# 2. Build LibreDWG (including dwg2svg)
WORKDIR /tmp
RUN git clone --depth 1 https://github.com/LibreDWG/libredwg.git && \
    cd libredwg && \
    ./autogen.sh && \
    ./configure --disable-static --enable-shared && \
    make -j"$(nproc)" all && \
    cp programs/dwg2svg /usr/local/bin/ && \
    make install && \
    ldconfig

# 3. (Non-fatal) show that dwg2svg exists; don't fail the build if it prints help
RUN ls -l /usr/local/bin/dwg2svg || true && /usr/local/bin/dwg2svg --help >/dev/null 2>&1 || true

# 4. Flask app
WORKDIR /app
COPY server.py /app/server.py
RUN pip3 install --no-cache-dir flask

EXPOSE 8080
ENV PORT=8080
CMD ["python3", "server.py"]
