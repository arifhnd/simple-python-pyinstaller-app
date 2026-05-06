# CI image khusus untuk pipeline Python
# Base image resmi Python slim — lebih kecil dari full image
FROM python:3.9-slim

# Install dependencies CI sekalian saat build image
# --no-cache-dir supaya image tidak bengkak
RUN pip install --no-cache-dir \
    pytest \
    pyinstaller

# Working directory default
WORKDIR /app