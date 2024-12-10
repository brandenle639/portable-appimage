# portable-appimage
Create portable appimages that can contain multiple apps and a full os

# appimage-container-builder
Build:

docker build -t [Image Name]:{Version You Want} {Path of the Docker File} --no-cache

Run:
docker run -it --rm --privileged -v {Scripts Folder}:/scripts [Image Name]:{Version You Want} bash



# Notes
Runs as non-root user

To set gui connection on host: xhost +

I don't own any of the install packages
