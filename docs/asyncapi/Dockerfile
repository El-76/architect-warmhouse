# Build stage
FROM asyncapi/cli:latest AS builder

USER root

# Set working directory
WORKDIR /app

# Copy go.mod and go.sum files
COPY async.yaml ./

# Build the application
RUN asyncapi generate fromTemplate /app/async.yaml @asyncapi/html-template --output /app/output

# Runtime stage
FROM nginx:alpine

# Copy the binary from the builder stage
COPY --from=builder /app/output /usr/share/nginx/html

