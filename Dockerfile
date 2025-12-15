# Stage 1: Build the Go application
FROM golang:1.22-alpine AS builder

WORKDIR /app

# Copy go.mod and go.sum to cache dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy the rest of the source code
COPY . .

# Build the Go application binary
RUN CGO_ENABLED=0 go build -o /app/go-backend .

# Stage 2: Create the final production image using Caddy
FROM caddy:2-alpine

# Set the working directory to the Caddy server root
WORKDIR /srv

# Copy the Caddyfile from the host to the container
COPY Caddyfile /etc/caddy/Caddyfile

# Copy the static files from the host to the Caddy server root
COPY public/ public/

# Copy the built Go binary from the builder stage to the Caddy server root
COPY --from=builder /app/go-backend /usr/local/bin/go-backend

# The Caddy image's entrypoint runs Caddy automatically.
# We just need to make sure the Go backend is running in the background.
# This requires a slight modification to the entrypoint command to run both processes.

# Overwrite the entrypoint script to start the Go backend in the background and then run Caddy
RUN echo "#!/bin/sh\n/usr/local/bin/go-backend &\n/usr/bin/caddy run --config /etc/caddy/Caddyfile --adapter caddyfile" > /usr/bin/start.sh
RUN chmod +x /usr/bin/start.sh

CMD ["/usr/bin/start.sh"]
