# Use an official Golang image to build the application
FROM golang:1.23 as builder

# Set the working directory inside the container
WORKDIR /app

# Copy the go.mod and go.sum files
COPY go.mod go.sum ./

# Download all dependencies
RUN go mod download

# Copy the source code
COPY . .

# Build the Go application
RUN go build -o ipfs-metadata .

# Use a minimal base image to run the application
FROM debian:bullseye-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the built binary from the builder stage
COPY --from=builder /app/ipfs-metadata .

# Copy the .env file
COPY .env .

# Expose the port the app runs on
EXPOSE 8080

# Command to run the application
CMD ["./ipfs-metadata"]

