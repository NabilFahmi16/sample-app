#!/bin/bash
# --------------------------------------------------------------
# Build and run sample Flask app with proper cleanup
# --------------------------------------------------------------

# === CLEAN UP OLD CONTAINER (MUST BE FIRST) ===
docker stop samplerunning 2>/dev/null || true
docker rm samplerunning 2>/dev/null || true

# === Remove old tempdir to avoid conflicts ===
rm -rf tempdir
mkdir -p tempdir/templates tempdir/static

# === Copy files ===
cp sample_app.py            tempdir/.
cp -r templates/*          tempdir/templates/. 2>/dev/null || true
cp -r static/*             tempdir/static/.    2>/dev/null || true

# === Create Dockerfile ===
cat > tempdir/Dockerfile <<'EOF'
FROM python:3.11-slim
RUN pip install --no-cache-dir flask
WORKDIR /home/myapp
COPY ./static    /home/myapp/static/
COPY ./templates /home/myapp/templates/
COPY sample_app.py /home/myapp/
EXPOSE 5050
CMD ["python", "/home/myapp/sample_app.py"]
EOF

# === Build & Run ===
cd tempdir
docker build -t sampleapp .
docker run -t -d --network host --name samplerunning sampleapp

# === Show running containers ===
docker ps -a