cd /tmp/
mkdir pybuilt
program="python{version}"
appcommand="usr\/local\/bin\/python{version}"
wget https://www.python.org/ftp/python/{version}/Python-{version}.tgz
tar xzf Python-{version}.tgz
chmod +x -R Python-{version}
cd Python-{version}
./configure --prefix=/usr/local --enable-shared LDFLAGS="-Wl,-rpath /usr/local/lib" --enable-optimizations --with-lto --with-computed-gotos --with-system-ffi --enable-shared
make -j "$(nproc)"
./python{version} -m test -j "$(nproc)"
make DESTDIR=/tmp/pybuilt install
rm /tmp/Python-{version}.tgz
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/tmp/pybuilt/usr/local/lib
/tmp/pybuilt/usr/local/bin/python{version} -m pip install --upgrade pip setuptools wheel PyInstaller
ln -s /usr/local/bin/python{version}        /usr/local/bin/python3
ln -s /usr/local/bin/python{version}        /usr/local/bin/python
ln -s /usr/local/bin/pip{version}           /usr/local/bin/pip3
ln -s /usr/local/bin/pip{version}           /usr/local/bin/pip
ln -s /usr/local/bin/pydoc{version}         /usr/local/bin/pydoc
ln -s /usr/local/bin/idle{version}          /usr/local/bin/idle
ln -s /usr/local/bin/python{version}-config      /usr/local/bin/python-config
cp -R /apptemplate /tmp/appmaker
cp -R /tmp/pybuilt/* /tmp/appmaker
sed -i -e "s/template/${program}/g" /tmp/appmaker/usr/share/metainfo/appimagetool.appdata.xml
sed -i -e "s/template/${program}/g" /tmp/appmaker/usr/share/applications/appimagetool.desktop
sed -i -e "s/template/${appcommand}/g" /tmp/appmaker/AppRun
awk 'NR==9{print "\nexport LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$this_dir/usr/local/lib"}1' /tmp/appmaker/AppRun > /tmp/appmaker/AppRune
sed -i -e 's/$LD_LIBRARY_PATH:$this_dir/$LD_LIBRARY_PATH:"$this_dir"/g' /tmp/appmaker/AppRune
cp /tmp/appmaker/AppRune /tmp/appmaker/AppRun
chmod a+x -R /tmp/appmaker
appimagetool -n /tmp/appmaker /tmp/python{version}.AppImage
