cd /tmp/
mkdir pybuilt
wget https://www.python.org/ftp/python/3.13.0/Python-3.13.0.tgz
tar xzf Python-3.13.0.tgz
chmod +x -R Python-3.13.0
cd Python-3.13.0
./configure --prefix=/usr/local --enable-shared LDFLAGS="-Wl,-rpath /usr/local/lib" --enable-optimizations --with-lto --with-computed-gotos --with-system-ffi --enable-shared
make -j "$(nproc)"
./python3.13 -m test -j "$(nproc)"
make DESTDIR=/tmp/pybuilt install
rm /tmp/Python-3.13.0.tgz
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/tmp/pybuilt/usr/local/lib
/tmp/pybuilt/usr/local/bin/python3.13 -m pip install --upgrade pip setuptools wheel PyInstaller
ln -s /usr/local/bin/python3.13        /usr/local/bin/python3
ln -s /usr/local/bin/python3.13        /usr/local/bin/python
ln -s /usr/local/bin/pip3.13           /usr/local/bin/pip3
ln -s /usr/local/bin/pip3.13           /usr/local/bin/pip
ln -s /usr/local/bin/pydoc3.13         /usr/local/bin/pydoc
ln -s /usr/local/bin/idle3.13          /usr/local/bin/idle
ln -s /usr/local/bin/python3.13-config      /usr/local/bin/python-config
cp -R /apptemplate /tmp/appmaker
cp -R /tmp/pybuilt/* /tmp/appmaker
sed -i -e "s/template/python3.13/g" /tmp/appmaker/usr/share/metainfo/appimagetool.appdata.xml
sed -i -e "s/template/python3.13/g" /tmp/appmaker/usr/share/applications/appimagetool.desktop
sed -i -e "s/template/usr\/local\/bin\/python3.13/g" /tmp/appmaker/AppRun
awk 'NR==9{print "\nexport LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$this_dir/usr/local/lib"}1' /tmp/appmaker/AppRun > /tmp/appmaker/AppRune
sed -i -e 's/$LD_LIBRARY_PATH:$this_dir/$LD_LIBRARY_PATH:"$this_dir"/g' /tmp/appmaker/AppRune
cp /tmp/appmaker/AppRune /tmp/appmaker/AppRun
chmod a+x -R /tmp/appmaker
appimagetool -n /tmp/appmaker /files/python3.13
