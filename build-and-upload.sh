#!/bin/bash

# Build script for go-whatsapp-outgoing Docker image
# Run this script on a server with Docker installed

set -e

IMAGE_NAME="go-whatsapp-outgoing"
IMAGE_TAG="latest"
OUTPUT_FILE="${IMAGE_NAME}.tar.gz"

echo "🔨 Building Docker image: ${IMAGE_NAME}:${IMAGE_TAG}"
docker build -t ${IMAGE_NAME}:${IMAGE_TAG} -f docker/golang.Dockerfile .

echo "📦 Exporting image to ${OUTPUT_FILE}"
docker save ${IMAGE_NAME}:${IMAGE_TAG} | gzip > ${OUTPUT_FILE}

echo "📊 File size:"
ls -lh ${OUTPUT_FILE}

echo "🚀 Uploading to 0x0.st..."
UPLOAD_URL=$(curl -s -F "file=@${OUTPUT_FILE}" https://0x0.st)

echo ""
echo "=========================================="
echo "✅ Build complete!"
echo "=========================================="
echo "Docker image: ${IMAGE_NAME}:${IMAGE_TAG}"
echo "Archive file: ${OUTPUT_FILE}"
echo "Download URL: ${UPLOAD_URL}"
echo ""
echo "To load on another server:"
echo "  curl -L ${UPLOAD_URL} | docker load"
echo "  # or"
echo "  docker load --input ${OUTPUT_FILE}"
echo ""
echo "To run:"
echo "  docker run -d -p 3000:3000 \\"
echo "    -e WHATSAPP_WEBHOOK=\"https://your-webhook.com/callback\" \\"
echo "    -e WHATSAPP_WEBHOOK_OUTGOING_MESSAGE=true \\"
echo "    ${IMAGE_NAME}:${IMAGE_TAG}"
echo "=========================================="
