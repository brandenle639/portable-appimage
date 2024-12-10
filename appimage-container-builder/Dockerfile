FROM debian:bookworm-slim
COPY appimagetool /usr/bin/appimagetool
COPY apptemplate /usr/bin/apptemplate
RUN apt-get update && apt-get upgrade -y && apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev liblzma-dev tk-dev file squashfs-tools desktop-file-utils zsync appstream fuse && chmod +x /usr/bin/appimagetool
