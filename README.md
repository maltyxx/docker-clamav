# maltyxx/docker-clamav

## About

🐳 [ClamAV](https://www.clamav.net) Docker image based on Alpine Linux.<br />
If you are interested, [check out](https://hub.docker.com/r/maltyxx/) my other 🐳 Docker images!

## Docker

### Supported multi architectures

- armv7 (arm32)
- armv8 (arm64)
- amd64 (x86_64)

### Volumes

* config : Contains files config
* data : Contains virus database

## Use this image

### Command line

You can also use the following minimal command :

```bash
docker run -d --name clamav --restart always -p 3310:3310 \
  -v config:/etc/clamav \
  -v data:/var/lib/clamav \
  maltyxx/clamav:latest
```

### Monitoring

```bash
docker exec -ti clamav clamdtop
```

### Update virus database

```bash
docker exec -ti clamav freshclam
```

### Scan on demande

```bash
docker exec -ti clamav clamscan -ri /
```
