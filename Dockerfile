FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# 1) Full toolchain & headers needed by LibreDWG and dwg2svg (SVG uses cairo/pango)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      build-essential git \
      autoconf automake libtool pkg-config \
      flex bison gperf gettext help2man texinfo \
      python3 python3-pip ca-certificates curl \
      zlib1g-dev libpng-dev libcairo2-dev libpango1.0-dev libxml2-dev \
      libfreetype6-dev libfontconfig1-dev && \
    rm -rf /var/lib/apt/lists/*

# 2) Build LibreDWG from source (provides dwg2svg and friends)
WORKDIR /tmp
RUN git clone --depth 1 https://github.com/LibreDWG/libredwg.git && \
    cd libredwg && \
    ./autogen.sh && \
    ./configure --disable-static --enable-shared && \
    make -j"$(nproc)" V=1 && \
    make install && \
    ldconfig

# 3) Sanity-check that dwg2svg is installed and runnable
RUN which dwg2svg && dwg2svg --help >/dev/null 2>&1

# 4) Your Flask app
WORKDIR /app
COPY server.py /app/server.py
RUN pip3 install --no-cache-dir flask

EXPOSE 8080
ENV PORT=8080
CMD ["python3", "server.py"]
