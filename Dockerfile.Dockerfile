{\rtf1\ansi\ansicpg1252\cocoartf2822
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 FROM debian:stable-slim\
\
RUN apt-get update && apt-get install -y python3 python3-pip libredwg-tools \\\
    && rm -rf /var/lib/apt/lists/*\
\
WORKDIR /app\
COPY server.py /app/server.py\
RUN pip3 install flask\
\
EXPOSE 8080\
ENV PORT=8080\
CMD ["python3", "server.py"]}