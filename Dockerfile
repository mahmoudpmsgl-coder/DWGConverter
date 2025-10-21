FROM debian:stable-slim

RUN apt-get update && apt-get install -y python3 python3-pip libredwg-tools \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY server.py /app/server.py
RUN pip3 install flask

EXPOSE 8080
ENV PORT=8080
CMD ["python3", "server.py"]
