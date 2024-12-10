cd /tmp
cp -R /apptemplate /tmp/appmaker
wget https://images.linuxcontainers.org/images/debian/bookworm/amd64/default/20241209_05%3A24/rootfs.tar.xz -O rootfs.tar.xz
tar xvf rootfs.tar.xz -C /tmp/appmaker
mkdir dwn
cd dwn
wget https://vscode.download.prss.microsoft.com/dbazure/download/stable/f1a4fb101478ce6ec82fe9627c43efbf9e98c813/code_1.95.3-1731513102_amd64.deb -O code.deb
declare -a PACKAGES=("bash" "binutils" "build-essential" "ca-certificates" "file" "gcc" "gedit" "libasound2" "libatk-bridge2.0-0" "libatk1.0-0" "libatspi2.0-0" "libbz2-dev" "libc6" "libcairo2" "libcurl3" "libcurl3-gnutls" "libcurl3-nss" "libcurl4" "libdbus-1-3" "libdrm2" "libexpat1" "libgbm1" "libglib2.0-0" "libgtk-3-0" "libgtk-4-1" "liblzma-dev" "libncurses5-dev" "libncursesw5-dev" "libnspr4" "libnss3" "libpango-1.0-0" "libreadline-dev" "libsqlite3-dev" "libssl-dev" "libssl3" "libvulkan1" "libx11-6" "libxcb1" "libxcomposite1" "libxdamage1" "libxext6" "libxfixes3" "libxkbcommon0" "libxkbfile1" "libxrandr2" "llvm" "make" "nano" "tk-dev" "xdg-utils" "xz-utils" "zlib1g-dev" "findutils")
for i in "${PACKAGES[@]}"
do
   echo "$i"
   apt-get download $(apt-cache depends --recurse --no-recommends --no-suggests \
   --no-conflicts --no-breaks --no-replaces --no-enhances \
   --no-pre-depends $i | grep "^\w")
done
for file in *; do
 dpkg-deb -x "$file" /tmp/appmaker
done
sed -i -e "s/template/bash/g" /tmp/appmaker/usr/share/metainfo/appimagetool.appdata.xml
sed -i -e "s/template/bash/g" /tmp/appmaker/usr/share/applications/appimagetool.desktop
sed -i -e '5a \\nPATH=$this_dir:$this_dir/usr/local/bin:$this_dir/usr/local/sbin:$this_dir/usr/local/bin:$this_dir/usr/sbin:$this_dir/usr/bin:$this_dir/sbin:$this_dir/bin' /tmp/appmaker/AppRun

###Specific Apps###

cnt=$(echo "$(($(sed -n '$=' /tmp/appmaker/AppRun)-1))")
if [ -d "/tmp/appmaker/usr/share/code" ]; then
 cnt=$(echo "$(($(sed -n '$=' /tmp/appmaker/AppRun)-1))")
 sed -i -e $cnt'a pths=$(find $this_dir/usr/share/code -mindepth 0 -maxdepth 1 -type d)\nfor it in $pths\ndo\n PATH=$PATH:$it\ndone\n' /tmp/appmaker/AppRun
fi

if [ -d "/tmp/appmaker/usr/share/code" ]; then
 cnt=$(echo "$(($(sed -n '$=' /tmp/appmaker/AppRun)-1))")
 sed -i -e $cnt'a pths=$(find $this_dir/usr/share/code -mindepth 0 -maxdepth 1 -type d)\nfor it in $pths\ndo\n LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$it\ndone\n' /tmp/appmaker/AppRun
fi

###################


if [ -d "/tmp/appmaker/usr/lib" ]; then
 cnt=$(echo "$(($(sed -n '$=' /tmp/appmaker/AppRun)-1))")
 sed -i -e $cnt'a pths=$(find $this_dir/usr/lib -mindepth 0 -maxdepth 999 -type d)\nfor it in $pths\ndo\n LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$it\ndone\n' /tmp/appmaker/AppRun
fi

if [ -d "/tmp/appmaker/usr/local/lib" ]; then
 cnt=$(echo "$(($(sed -n '$=' /tmp/appmaker/AppRun)-1))")
 sed -i -e $cnt'a pths=$(find $this_dir/usr/local/lib -mindepth 0 -maxdepth 999 -type d)\nfor it in $pths\ndo\n LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$it\ndone\n' /tmp/appmaker/AppRun
fi


cnt=$(echo "$(($(sed -n '$=' /tmp/appmaker/AppRun)-1))")
sed -i -e $cnt'a export PATH=$PATH\n' /tmp/appmaker/AppRun

cnt=$(echo "$(($(sed -n '$=' /tmp/appmaker/AppRun)-1))")
sed -i -e $cnt'a export LD_LIBRARY_PATH=$LD_LIBRARY_PATH\n' /tmp/appmaker/AppRun

cnt=$(echo "$(($(sed -n '$=' /tmp/appmaker/etc/sudoers)))")
sed -i -e $cnt'a \\n* ALL=(ALL) ALL' /tmp/appmaker/etc/sudoers

cnt=$(echo "$(($(sed -n '$=' /tmp/appmaker/AppRun)-1))")
sed -i -e $cnt'a if [ "$#" -lt 1 ]; then' /tmp/appmaker/AppRun
sed -i -e 's/exec "$this_dir"\/template "$@"/ exec "$this_dir"\/template "$@"/g' /tmp/appmaker/AppRun
cnt=$(echo "$(($(sed -n '$=' /tmp/appmaker/AppRun)))")
sed -i -e $cnt'a else' /tmp/appmaker/AppRun
cnt=$(echo "$(($(sed -n '$=' /tmp/appmaker/AppRun)))")
sed -i -e $cnt'a\ exec "$@"' /tmp/appmaker/AppRun
cnt=$(echo "$(($(sed -n '$=' /tmp/appmaker/AppRun)))")
sed -i -e $cnt'a fi' /tmp/appmaker/AppRun
sed -i -e "s/template/bin\/bash/g" /tmp/appmaker/AppRun

chmod a+x -R /tmp/appmaker
chown -R root:root /tmp/appmaker/usr && chmod -R 4755 /tmp/appmaker/usr
appimagetool -n /tmp/appmaker /tmp/termbashprogargs
