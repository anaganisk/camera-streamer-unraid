# Use Debian Bullseye as the base image
FROM debian:bullseye-slim
# Set environment variables to avoid prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV TAG_NAME=$TAG_NAME
# Update apt and install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*
# Download and install the required dependencies
RUN apt-get update && apt-get install -y \
    libavcodec58 \
    libavformat58 \
    libavutil56 \
    && rm -rf /var/lib/apt/lists/*
# Download and install the camera-streamer package
RUN curl -L -o camera-streamer.deb "https://github.com/ayufan/camera-streamer/releases/download/v${TAG_NAME}/camera-streamer-generic_${TAG_NAME}.bullseye_amd64.deb" \
    && dpkg -i camera-streamer.deb || apt-get install -f
# Cleanup
RUN rm -f camera-streamer.deb
# Expose port
EXPOSE 8080
# Set the default command to execute
CMD ["camera-streamer"]
