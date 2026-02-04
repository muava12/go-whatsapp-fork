# Build Instructions for Debian Server

## Prerequisites
Install Docker jika belum ada:
```bash
# Update packages
sudo apt update

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add user to docker group (optional, agar tidak perlu sudo)
sudo usermod -aG docker $USER
# Logout dan login kembali agar group aktif
```

## Build Steps

### 1. Download source code
```bash
# Ganti URL_DARI_0X0ST dengan link yang didapat dari upload
curl -L "URL_DARI_0X0ST" -o go-whatsapp-outgoing-source.tar.gz
```

### 2. Extract source
```bash
mkdir go-whatsapp-outgoing && cd go-whatsapp-outgoing
tar -xzvf ../go-whatsapp-outgoing-source.tar.gz
```

### 3. Build Docker image
```bash
docker build -t go-whatsapp-outgoing:latest -f docker/golang.Dockerfile .
```

### 4. Export image ke tar.gz
```bash
docker save go-whatsapp-outgoing:latest | gzip > go-whatsapp-outgoing.tar.gz
```

### 5. (Opsional) Upload ke 0x0.st
```bash
curl -A "Mozilla/5.0" -F "file=@go-whatsapp-outgoing.tar.gz" https://0x0.st
```

## Atau jalankan script otomatis
```bash
chmod +x build-and-upload.sh
./build-and-upload.sh
```

---

## Running the Container

### Basic run
```bash
docker run -d -p 3000:3000 go-whatsapp-outgoing:latest
```

### With webhook outgoing message enabled
```bash
docker run -d -p 3000:3000 \
  -e WHATSAPP_WEBHOOK="https://your-webhook.com/callback" \
  -e WHATSAPP_WEBHOOK_OUTGOING_MESSAGE=true \
  -v $(pwd)/storages:/app/storages \
  go-whatsapp-outgoing:latest
```

### Load image di server lain
```bash
# Dari file lokal
docker load --input go-whatsapp-outgoing.tar.gz

# Atau langsung dari URL
curl -L "URL_DARI_0X0ST" | docker load
```

---

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `WHATSAPP_WEBHOOK` | - | Webhook URL untuk menerima events |
| `WHATSAPP_WEBHOOK_OUTGOING_MESSAGE` | `false` | Set `true` untuk mengirim pesan keluar ke webhook |
| `WHATSAPP_WEBHOOK_SECRET` | `secret` | HMAC secret untuk verifikasi webhook |
| `WHATSAPP_AUTO_MARK_READ` | `false` | Auto mark pesan sebagai dibaca |
| `APP_PORT` | `3000` | Port aplikasi |
| `APP_DEBUG` | `false` | Enable debug mode |
