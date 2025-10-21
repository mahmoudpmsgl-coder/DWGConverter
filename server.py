{\rtf1\ansi\ansicpg1252\cocoartf2822
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 import os, tempfile, subprocess\
from flask import Flask, request, jsonify\
\
app = Flask(__name__)\
\
@app.route("/convert", methods=["POST"])\
def convert():\
    f = request.files.get("file")\
    if not f:\
        return jsonify(error="missing file"), 400\
\
    with tempfile.TemporaryDirectory() as td:\
        dwg_path = os.path.join(td, f.filename)\
        f.save(dwg_path)\
        svg_path = os.path.join(td, "out.svg")\
\
        try:\
            subprocess.check_call(["dwg2svg", dwg_path, svg_path])\
        except subprocess.CalledProcessError:\
            return jsonify(error="dwg2svg failed"), 422\
\
        with open(svg_path, "r", encoding="utf-8") as fh:\
            svg_text = fh.read()\
    return jsonify(svg=svg_text), 200\
\
if __name__ == "__main__":\
    port = int(os.environ.get("PORT", "8080"))\
    app.run(host="0.0.0.0", port=port)}