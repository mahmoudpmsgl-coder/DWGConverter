FROM ubuntu:22.04

# Avoid interactive prompts in containers
ENV DEBIAN_FRONTEND=noninteractive

# Install Python + LibreDWG CLI
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      python3 python3-pip libredwg-tools ca-certificates && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY server.py /app/server.py
RUN pip3 install --no-cache-dir flask

EXPOSE 8080
ENV PORT=8080
CMD ["python3", "server.py"]
