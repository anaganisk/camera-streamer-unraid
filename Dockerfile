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
CMD ["/usr/bin/camera-streamer", "-camera-nbufs=3", "--http-listen=0.0.0.0", "--http-port=8080", "-camera-video.disabled", "-camera-path=/dev/video0", "-camera-format=JPEG", "-camera-width=1920", "-camera-height=1080", "-camera-fps=30"]
