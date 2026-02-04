############################
# STEP 1 build executable binary
############################
FROM golang:1.23-alpine AS builder
RUN apk update && apk add --no-cache gcc musl-dev gcompat
WORKDIR /whatsapp
COPY ./src .

# Fetch dependencies.
RUN go mod download
# Build the binary with optimizations
RUN go build -a -ldflags="-w -s" -o /app/whatsapp

#############################
## STEP 2 build a smaller image
#############################
FROM alpine:latest
RUN apk add --no-cache ffmpeg libwebp-tools tzdata
ENV TZ=UTC
WORKDIR /app
# Copy compiled from builder.
COPY --from=builder /app/whatsapp /app/whatsapp
# Run the binary.
ENTRYPOINT ["/app/whatsapp"]

CMD [ "rest" ]