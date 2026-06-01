#!/bin/bash
set -e

rm -rf tempdir
mkdir -p tempdir/templates
mkdir -p tempdir/static

cp sample_app.py tempdir/
cp -r templates/* tempdir/templates/
cp -r static/* tempdir/static/

cat > tempdir/Dockerfile <<'EOF'
FROM python:3.10-slim

WORKDIR /home/myapp

COPY ./static /home/myapp/static/
COPY ./templates /home/myapp/templates/
COPY sample_app.py /home/myapp/

RUN python -m pip install --no-cache-dir --progress-bar off flask

EXPOSE 9999

CMD ["python", "/home/devasc/labs/devnet-src/jenkins/sample-app/sample_app.py"]
EOF

cd tempdir

docker rm -f samplerunning || true
docker build --no-cache -t sampleapp .
docker run -d -p 9999:9999 --name samplerunning sampleapp
docker ps -a
