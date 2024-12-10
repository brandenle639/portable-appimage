cd /tmp
program="bash"
appcommand="bin\/bash"
cp -R /apptemplate /tmp/appmaker
wget https://images.linuxcontainers.org/images/debian/bookworm/amd64/default/20241209_05%3A24/rootfs.tar.xz -O rootfs.tar.xz
tar xvf rootfs.tar.xz -C /tmp/appmaker
mkdir dwn
cd dwn
declare -a PACKAGES=("findutils")
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
sed -i -e "s/template/${program}/g" /tmp/appmaker/usr/share/metainfo/appimagetool.appdata.xml
sed -i -e "s/template/${program}/g" /tmp/appmaker/usr/share/applications/appimagetool.desktop
sed -i -e "s/template/${appcommand}/g" /tmp/appmaker/AppRun
sed -i -e '5a \\nPATH=$this_dir:$this_dir/usr/local/bin:$this_dir/usr/local/sbin:$this_dir/usr/local/bin:$this_dir/usr/sbin:$this_dir/usr/bin:$this_dir/sbin:$this_dir/bin' /tmp/appmaker/AppRun


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

chmod a+x -R /tmp/appmaker
chown -R root:root /tmp/appmaker/usr && chmod -R 4755 /tmp/appmaker/usr
appimagetool -n /tmp/appmaker /tmp/template.AppImage
