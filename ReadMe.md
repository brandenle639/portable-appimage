# portable-appimage
Create portable appimages that can contain multiple apps and a full os

# appimage-container-builder
Build:

docker build -t [Image Name]:{Version You Want} {Path of the Docker File} --no-cache

Run:

1. docker run -it --rm --privileged -v {Scripts Folder}:/scripts [Image Name]:{Version You Want} bash

2. Run the related script and copy the AppImage from the temp folder to the mounted folder

# Scripts
Files:

    bashcore-selfcontained.sh - Self contained rootfs bash

    bashcore-selfcontainedargs.sh - Self contained rootfs bash that can run other apps by default

    python3130.sh - Builds Self contained rootfs with Python v3.13.0 from Python scratch

    python-template.sh - Builds Self contained rootfs with Python from Python scratch

    template-selfcontained.sh - Template for new app images

    template-selfcontainedargs.sh - Template for new app images args

    vscode-app-selfcontained.sh - Builds Self contained rootfs with terminal based with Visual Studio code

    vscode-app-selfcontainedargs.sh - Builds Self contained rootfs with arguments with Visual Studio code

Example with arguments:

    ./appimageargs.AppImage {Args}

To create a new app image:

    Copy the related template file you want and then edit the following:

    Edit the 'program' variable with the related app

    Edit the 'appcommand' variable with the related app

    Add the related package(s) to the 'PACKAGES' array or copy the wget command to download the related package to the "/tmp/dwn" folder.

    In python-template edit '{version}' with the related python version

# Notes
The AppImage doesn't give root privilages unless run as root

Gets the rootfs from https://images.linuxcontainers.org/images

Template based on https://appimage.org/

Requires: FUSE

I don't own any of the install packages
