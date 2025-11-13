#!/bin/bash
# --------------------------------------------------------------
# Build the sample Flask app inside a Docker image and run it
# --------------------------------------------------------------

# 1. Create a clean temp directory
rm -rf tempdir
mkdir -p tempdir/templates tempdir/static

# 2. Copy source files
cp sample_app.py            tempdir/.
cp -r templates/*          tempdir/templates/. 2>/dev/null || true
cp -r static/*             tempdir/static/.    2>/dev/null || true

# 3. Write Dockerfile
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

# 4. Build & run
cd tempdir
docker build -t sampleapp .
# --network host makes the container share the host (Jenkins) network
docker run -t -d --network host --name samplerunning sampleapp

# 5. Show what is running
docker ps -a