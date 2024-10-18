echo " DOWNLOAD AND INSTALL multi-stalkerpro "
versions="1.2"
TMPDIR='/tmp'
PLUGINPATH='/usr/lib/enigma2/python/Plugins/Extensions/MultiStalkerPro'
SETTINGS='/etc/enigma2/settings'
URL='https://raw.githubusercontent.com/emilnabil/multi-stalkerpro/main'
PYTHON_VERSION=$(python -c "import platform; print(platform.python_version())")

# 
if [ -f /etc/apt/apt.conf ]; then
    INSTALL="apt-get install -y"
    OPKGREMOV="apt-get purge --auto-remove -y"
    CHECK_INSTALLED="dpkg -l"
    OS="DreamOS"
elif [ -f /etc/opkg/opkg.conf ]; then
    INSTALL="opkg install --force-reinstall --force-depends"
    OPKGREMOV="opkg remove --force-depends"
    CHECK_INSTALLED="opkg list-installed"
    OS="Opensource"
else
    echo "Unsupported OS"
    exit 1
fi

# 
if python --version 2>&1 | grep -q '^Python 3\.'; then
    echo "You have Python3 image"
    PYTHON='PY3'
else
    echo "You have Python2 image"
    PYTHON='PY2'
fi
declare -A packages
if [ "$PYTHON" = 'PY3' ]; then
    packages=(
        ["p7zip"]=1 ["tar"]=1 ["wget"]=1 ["zip"]=1 ["ar"]=1 ["curl"]=1 ["python3-lxml"]=1 ["python3-requests"]=1
        ["python3-beautifulsoup4"]=1 ["python3-cfscrape"]=1 ["livestreamersrv"]=1
        ["python3-six"]=1 ["python3-sqlite3"]=1 ["python3-pycrypto"]=1 ["f4mdump"]=1
        ["python3-image"]=1 ["python3-imaging"]=1 ["python3-argparse"]=1
        ["python3-multiprocessing"]=1 ["python3-mmap"]=1 ["python3-ndg-httpsclient"]=1
        ["python3-pydoc"]=1 ["python3-xmlrpc"]=1 ["python3-certifi"]=1 ["python3-urllib3"]=1
        ["python3-chardet"]=1 ["python3-pysocks"]=1 ["python3-js2py"]=1 ["python3-pillow"]=1
        ["enigma2-plugin-systemplugins-serviceapp"]=1 ["ffmpeg"]=1 ["exteplayer3"]=1
        ["gstplayer"]=1 ["gstreamer1.0-plugins-good"]=1 ["gstreamer1.0-plugins-ugly"]=1
        ["gstreamer1.0-plugins-base"]=1 ["gstreamer1.0-plugins-bad"]=1
    )
elif [ "$PYTHON" = 'PY2' ]; then
    packages=(
        ["wget"]=1 ["tar"]=1 ["zip"]=1 ["ar"]=1 ["curl"]=1 ["hlsdl"]=1 ["python-lxml"]=1 ["python-requests"]=1
        ["python-beautifulsoup4"]=1 ["python-cfscrape"]=1 ["livestreamer"]=1
        ["python-six"]=1 ["python-sqlite3"]=1 ["python-pycrypto"]=1
        ["f4mdump"]=1 ["python-image"]=1 ["python-imaging"]=1 ["python-argparse"]=1
        ["python-multiprocessing"]=1 ["python-mmap"]=1 ["python-ndg-httpsclient"]=1
        ["python-pydoc"]=1 ["python-xmlrpc"]=1 ["python-certifi"]=1 ["python-urllib3"]=1
        ["python-chardet"]=1 ["python-pysocks"]=1 ["enigma2-plugin-systemplugins-serviceapp"]=1
        ["ffmpeg"]=1 ["exteplayer3"]=1 ["gstplayer"]=1 ["gstreamer1.0-plugins-good"]=1
        ["gstreamer1.0-plugins-ugly"]=1 ["gstreamer1.0-plugins-base"]=1 ["gstreamer1.0-plugins-bad"]=1
    )
else
    echo "Python 2 or 3 is required."
fi

# 
for package in "${!packages[@]}"; do
    if ! $CHECK_INSTALLED | grep -qw "$package"; then
        echo "Installing $package..."
        $INSTALL "$package" >/dev/null 2>&1
    else
        echo "$package is already installed or an updated version is available. Ok"
    fi
done

echo "**************************************************************"
echo "   UPLOADED BY  >>>>   EMIL_NABIL "
sleep 4

# 
if [ -e /etc/enigma2/MultiStalkerPro.json ]; then
    cp -f /etc/enigma2/MultiStalkerPro.json /tmp
fi

# 
echo "Removing Old Package"
$OPKGREMOV enigma2-plugin-extensions-multi-stalkerpro

OLDPACKAGE=(
    "/usr/lib/enigma2/python/Plugins/Extensions/MultiStalkerPro"
    "/usr/lib/enigma2/python/Components/Converter/MultiStalkerAudioInfo*"
    "/usr/lib/enigma2/python/Components/Converter/MultiStalkerProServicePosition*"
    "/usr/lib/enigma2/python/Components/Converter/MultiStalkerProServiceResolution*"
    "/usr/lib/enigma2/python/Components/Renderer/MultiStalkerAudioIcon*"
    "/usr/lib/enigma2/python/Components/Renderer/MultiStalkerProRunningText*"
    "/usr/lib/enigma2/python/Components/Renderer/MultiStalkerProStars*"
)
for path in "${OLDPACKAGE[@]}"; do
    if [ -d "$path" ]; then
        rm -rf "$path"
    fi
done
echo "Old Package removed"

# 
case "$PYTHON_VERSION" in
    3.11.*)
        echo ":You have $PYTHON_VERSION image ..."
        PYTHONLASTV='PY3'
        IMAGING='python3-imaging'
        PYSIX='python3-six'
        ;;
    3.12.[1-9])
        echo ":You have $PYTHON_VERSION image ..."
        PYTHONLASTER='PY3'
        PYSIX='python3-six'
        ;;

  3.9.9|3.9.7|3.9.6|3.8.5)
    echo ":You have $PYTHON_VERSION image ..."
    PYTHONL='PY3'
    IMAGING='python3-imaging'
    PYSIX='python3-six'
        ;;
    2.7.18)
        echo ":You have $PYTHON_VERSION image ..."
        PYTHON='PY2'
        PYSIX='python-six'
        ;;
    *)
        echo "Python is not supported"
        sleep 4
        exit 1
        ;;
esac
# 
CHECK='/tmp/check'
uname -m > $CHECK
sleep 1;
if grep -qs -i 'mips' cat $CHECK ; then
echo "[ Your device is MIPS ]"
if [ "$PYTHON" = "PY2" ]; then
wget -q  "--no-check-certificate" https://raw.githubusercontent.com/emilnabil/multi-stalkerpro/main/multi-stalkerpro-py2.7_mips32el.tar.gz -O /tmp/multi-stalkerpro-py2.7_mips32el.tar.gz
tar -xzf /tmp/multi-stalkerpro-py2.7_mips32el.tar.gz -C /
sleep 2;
rm -f /tmp/multi-stalkerpro-py2.7_mips32el.tar.gz
elif [ "$PYTHONLASTER" = "PY3" ]; then
$OPKGREMOV enigma2-plugin-extensions-multi-stalkerpro
sleep 1;
cd /tmp
curl  -k -Lbk -m 55532 -m 555104 "https://raw.githubusercontent.com/emilnabil/multi-stalkerpro/main/multi-stalkerpro-py3.12_mips32el.ipk" > /tmp/multi-stalkerpro-py3.12_mips32el.ipk
$INSTALL /tmp/multi-stalkerpro-py3.12_mips32el.ipk
sleep 2
rm -f /tmp/multi-stalkerpro-py3.12_mips32el.ipk
echo ""
if [ -e /tmp/MultiStalkerPro.json ]; then
rm -f /etc/enigma2/MultiStalkerPro.json
cp -f /tmp/MultiStalkerPro.json /etc/enigma2/MultiStalkerPro.json
fi
echo ""
elif (grep -qs -i "openvix" /etc/image-version); then
$OPKGREMOV enigma2-plugin-extensions-multi-stalkerpro
rm -rf "$path"
sleep 1;
cd /tmp
curl  -k -Lbk -m 55532 -m 555104 "https://raw.githubusercontent.com/emilnabil/multi-stalkerpro/main/python3-rarfile_4.1-r0_mips32el.ipk" > /tmp/python3-rarfile_4.1-r0_mips32el.ipk
$INSTALL /tmp/python3-rarfile_4.1-r0_mips32el.ipk
sleep 2
rm -f /tmp/python3-rarfile_4.1-r0_mips32el.ipk
echo ""
sleep 1;
cd /tmp
curl  -k -Lbk -m 55532 -m 555104 "https://raw.githubusercontent.com/emilnabil/multi-stalkerpro/main/multi-stalkerpro-py3.12_mips32el-openvix-openbh.ipk" > /tmp/multi-stalkerpro-py3.12_mips32el-openvix-openbh.ipk
$INSTALL /tmp/multi-stalkerpro-py3.12_mips32el-openvix-openbh.ipk
sleep 2
rm -f /tmp/multi-stalkerpro-py3.12_mips32el-openvix-openbh.ipk
echo ""
echo ""
if [ -e /tmp/MultiStalkerPro.json ]; then
rm -f /etc/enigma2/MultiStalkerPro.json
cp -f /tmp/MultiStalkerPro.json /etc/enigma2/MultiStalkerPro.json
fi
echo ""
elif (grep -qs -i "openbh" /etc/image-version); then
$OPKGREMOV enigma2-plugin-extensions-multi-stalkerpro
rm -rf "$path"
sleep 1;
cd /tmp
curl  -k -Lbk -m 55532 -m 555104 "https://raw.githubusercontent.com/emilnabil/multi-stalkerpro/main/python3-rarfile_4.1-r0_mips32el.ipk" > /tmp/python3-rarfile_4.1-r0_mips32el.ipk
$INSTALL /tmp/python3-rarfile_4.1-r0_mips32el.ipk
sleep 2
rm -f /tmp/python3-rarfile_4.1-r0_mips32el.ipk
echo ""
sleep 1;
cd /tmp
curl  -k -Lbk -m 55532 -m 555104 "https://raw.githubusercontent.com/emilnabil/multi-stalkerpro/main/multi-stalkerpro-py3.12_mips32el-openvix-openbh.ipk" > /tmp/multi-stalkerpro-py3.12_mips32el-openvix-openbh.ipk
$INSTALL /tmp/multi-stalkerpro-py3.12_mips32el-openvix-openbh.ipk
sleep 2
rm -f /tmp/multi-stalkerpro-py3.12_mips32el-openvix-openbh.ipk
echo ""
echo ""
if [ -e /tmp/MultiStalkerPro.json ]; then
rm -f /etc/enigma2/MultiStalkerPro.json
cp -f /tmp/MultiStalkerPro.json /etc/enigma2/MultiStalkerPro.json
fi
echo ""
elif [ "$PYTHONL" = "PY3" ]; then
if (grep -qs -i openpli /etc/issue); then
rm -rf "$path"
sleep 1;
cd /tmp
curl  -k -Lbk -m 55532 -m 555104 "https://raw.githubusercontent.com/emilnabil/multi-stalkerpro/main/python3.9-rarfile_4.1-r0_mips32el.ipk" > /tmp/python3.9-rarfile_4.1-r0_mips32el.ipk
$INSTALL /tmp/python3.9-rarfile_4.1-r0_mips32el.ipk
sleep 2
rm -f /tmp/python3.9-rarfile_4.1-r0_mips32el.ipk
echo ""
sleep 1;
cd /tmp
curl  -k -Lbk -m 55532 -m 555104 "https://raw.githubusercontent.com/emilnabil/multi-stalkerpro/main/python3.9-levenshtein_0.12.0-r0_mips32el.ipk" > /tmp/python3.9-levenshtein_0.12.0-r0_mips32el.ipk
$INSTALL /tmp/python3.9-levenshtein_0.12.0-r0_mips32el.ipk
sleep 2
rm -f /tmp/python3.9-levenshtein_0.12.0-r0_mips32el.ipk
echo ""
sleep 1;
cd /tmp
curl  -k -Lbk -m 55532 -m 555104 "https://raw.githubusercontent.com/emilnabil/multi-stalkerpro/main/python3.9-fuzzywuzzy_0.18.0-r0_mips32el.ipk" > /tmp/python3.9-fuzzywuzzy_0.18.0-r0_mips32el.ipk
$INSTALL /tmp/python3.9-fuzzywuzzy_0.18.0-r0_mips32el.ipk
sleep 2
rm -f /tmp/python3.9-fuzzywuzzy_0.18.0-r0_mips32el.ipk
echo ""
sleep 1;
cd /tmp
curl  -k -Lbk -m 55532 -m 555104 "https://raw.githubusercontent.com/emilnabil/multi-stalkerpro/main/multi-stalkerpro_mipsel-py3.9-openpli-develop.ipk" > /tmp/multi-stalkerpro_mipsel-py3.9-openpli-develop.ipk
$INSTALL /tmp/multi-stalkerpro_mipsel-py3.9-openpli-develop.ipk
sleep 2
rm -f /tmp/multi-stalkerpro_mipsel-py3.9-openpli-develop.ipk
echo ""
echo ""
if [ -e /tmp/MultiStalkerPro.json ]; then
rm -f /etc/enigma2/MultiStalkerPro.json
cp -f /tmp/MultiStalkerPro.json /etc/enigma2/MultiStalkerPro.json
fi
echo ""
else
echo ""
sleep 4;
fi
fi
elif grep -qs -i 'armv7l' cat $CHECK ; then
echo "[ Your device is armv7l ]"
if [ "$PYTHONLASTV" = "PY3" ]; then
wget -q  "--no-check-certificate" https://raw.githubusercontent.com/emilnabil/multi-stalkerpro/main/multi-stalkerpro-py3.11_arm.tar.gz -O /tmp/multi-stalkerpro-py3.11_arm.tar.gz
tar -xzf /tmp/multi-stalkerpro-py3.11_arm.tar.gz -C /
sleep 2;
rm -f /tmp/multi-stalkerpro-py3.11_arm.tar.gz
elif [ "$PYTHONLASTER" = "PY3" ]; then
$OPKGREMOV enigma2-plugin-extensions-multi-stalkerpro
sleep 1
if (grep -qs -i "openvix" /etc/image-version); then
rm -rf "$path"
sleep 1;
cd /tmp
curl  -k -Lbk -m 55532 -m 555104 "https://raw.githubusercontent.com/emilnabil/multi-stalkerpro/main/python3-rarfile_4.1-r0_cortexa15hf-neon-vfpv4.ipk" > /tmp/python3-rarfile_4.1-r0_cortexa15hf-neon-vfpv4.ipk
$INSTALL /tmp/python3-rarfile_4.1-r0_cortexa15hf-neon-vfpv4.ipk
sleep 2
rm -f /tmp/python3-rarfile_4.1-r0_cortexa15hf-neon-vfpv4.ipk
sleep 1;
cd /tmp
curl  -k -Lbk -m 55532 -m 555104 "https://raw.githubusercontent.com/emilnabil/multi-stalkerpro/main/multi-stalkerpro-py3.12_arm-openvix-openbh.ipk" > /tmp/multi-stalkerpro-py3.12_arm-openvix-openbh.ipk
$INSTALL /tmp/multi-stalkerpro-py3.12_arm-openvix-openbh.ipk
sleep 2
rm -f /tmp/multi-stalkerpro-py3.12_arm-openvix-openbh.ipk
echo ""
echo ""
if [ -e /tmp/MultiStalkerPro.json ]; then
rm -f /etc/enigma2/MultiStalkerPro.json
cp -f /tmp/MultiStalkerPro.json /etc/enigma2/MultiStalkerPro.json
fi
echo ""
elif (grep -qs -i "openbh" /etc/image-version); then
rm -rf "$path"
sleep 1;
cd /tmp
curl  -k -Lbk -m 55532 -m 555104 "https://raw.githubusercontent.com/emilnabil/multi-stalkerpro/main/python3-rarfile_4.1-r0_cortexa15hf-neon-vfpv4.ipk" > /tmp/python3-rarfile_4.1-r0_cortexa15hf-neon-vfpv4.ipk
$INSTALL /tmp/python3-rarfile_4.1-r0_cortexa15hf-neon-vfpv4.ipk
sleep 2
rm -f /tmp/python3-rarfile_4.1-r0_cortexa15hf-neon-vfpv4.ipk
sleep 1;
cd /tmp
curl  -k -Lbk -m 55532 -m 555104 "https://raw.githubusercontent.com/emilnabil/multi-stalkerpro/main/multi-stalkerpro-py3.12_arm-openvix-openbh.ipk" > /tmp/multi-stalkerpro-py3.12_arm-openvix-openbh.ipk
$INSTALL /tmp/multi-stalkerpro-py3.12_arm-openvix-openbh.ipk
sleep 2
rm -f /tmp/multi-stalkerpro-py3.12_arm-openvix-openbh.ipk
echo ""
wget -O /etc/enigma2/MultiStalkerPro.json "https://raw.githubusercontent.com/emilnabil/multi-stalkerpro/main/MultiStalkerPro.json"
echo ""
else
cd /tmp
curl  -k -Lbk -m 55532 -m 555104 "https://github.com/emilnabil/multi-stalkerpro/raw/main/multi-stalkerpro-py3.12_arm.ipk" > /tmp/multi-stalkerpro-py3.12_arm.ipk
sleep 1
cd /tmp
$INSTALL multi-stalkerpro-py3.12_arm.ipk
echo ""
echo ""
echo ""
if [ -e /tmp/MultiStalkerPro.json ]; then
rm -f /etc/enigma2/MultiStalkerPro.json
cp -f /tmp/MultiStalkerPro.json /etc/enigma2/MultiStalkerPro.json
fi
echo ""
echo ""
echo ""
echo ""
echo ""
sleep 1
rm /tmp/multi-stalkerpro-py3.12_arm.ipk
fi
fi
fi
if [ "$PYTHONL" = "PY3" ]; then
if (grep -qs -i openpli /etc/issue); then
$OPKGREMOV enigma2-plugin-extensions-multi-stalkerpro
rm -rf "$path"
cd /tmp
curl  -k -Lbk -m 55532 -m 555104 "https://raw.githubusercontent.com/emilnabil/multi-stalkerpro/main/python3-rarfile_4.1-r0_armv7ahf-neon.ipk" > /tmp/python3-rarfile_4.1-r0_armv7ahf-neon.ipk
$INSTALL /tmp/python3-rarfile_4.1-r0_armv7ahf-neon.ipk
sleep 2
rm -f /tmp/python3-rarfile_4.1-r0_armv7ahf-neon.ipk
sleep 1;
cd /tmp
curl  -k -Lbk -m 55532 -m 555104 "https://raw.githubusercontent.com/emilnabil/multi-stalkerpro/main/python3-levenshtein_0.12.0-r0_armv7ahf-neon.ipk" > /tmp/python3-levenshtein_0.12.0-r0_armv7ahf-neon.ipk
$INSTALL /tmp/python3-levenshtein_0.12.0-r0_armv7ahf-neon.ipk
sleep 2
rm -f /tmp/python3-levenshtein_0.12.0-r0_armv7ahf-neon.ipk
sleep 1;
cd /tmp
curl  -k -Lbk -m 55532 -m 555104 "https://raw.githubusercontent.com/emilnabil/multi-stalkerpro/main/python3-fuzzywuzzy_0.18.0-r0_armv7ahf-neon.ipk" > /tmp/python3-fuzzywuzzy_0.18.0-r0_armv7ahf-neon.ipk
$INSTALL /tmp/python3-fuzzywuzzy_0.18.0-r0_armv7ahf-neon.ipk
sleep 2
rm -f /tmp/python3-fuzzywuzzy_0.18.0-r0_armv7ahf-neon.ipk
sleep 1;
cd /tmp
curl  -k -Lbk -m 55532 -m 555104 "https://raw.githubusercontent.com/emilnabil/multi-stalkerpro/main/multi-stalkerpro_openpli-develop.ipk" > /tmp/multi-stalkerpro_openpli-develop.ipk
$INSTALL /tmp/multi-stalkerpro_openpli-develop.ipk
sleep 2
rm -f /tmp/multi-stalkerpro_openpli-develop.ipk
sleep 1;
if [ -e /tmp/MultiStalkerPro.json ]; then
rm -f /etc/enigma2/MultiStalkerPro.json
cp -f /tmp/MultiStalkerPro.json /etc/enigma2/MultiStalkerPro.json
fi
echo ""
echo ""
fi
fi
if [ "$PYTHON" = "PY2" ]; then
wget -q  "--no-check-certificate" https://raw.githubusercontent.com/emilnabil/multi-stalkerpro/main/multi-stalkerpro-py2.7_arm.tar.gz -O /tmp/multi-stalkerpro-py2.7_arm.tar.gz
sleep 1;
tar -xzf /tmp/multi-stalkerpro-py2.7_arm.tar.gz -C /
sleep 2;
rm -f /tmp/multi-stalkerpro-py2.7_arm.tar.gz
echo ""
sleep 2;
fi
echo ""
if grep -qs -i 'aarch64' cat $CHECK ; then
echo "[ Your device is aarch64 ]"
if [ "$PYTHONLASTER" = "PY3" ]; then
$OPKGREMOV enigma2-plugin-extensions-multi-stalkerpro
sleep 1;
cd /tmp
curl  -k -Lbk -m 55532 -m 555104 "https://raw.githubusercontent.com/emilnabil/multi-stalkerpro/main/multi-stalkerpro-py3.12_aarch64.ipk" > /tmp/multi-stalkerpro-py3.12_aarch64.ipk
$INSTALL /tmp/multi-stalkerpro-py3.12_aarch64.ipk
sleep 2
rm -f /tmp/multi-stalkerpro-py3.12_aarch64.ipk
echo ""
if [ -e /tmp/MultiStalkerPro.json ]; then
rm -f /etc/enigma2/MultiStalkerPro.json
cp -f /tmp/MultiStalkerPro.json /etc/enigma2/MultiStalkerPro.json
fi
echo ""
elif (grep -qs -i "openvix" /etc/image-version); then
rm -rf "$path"
sleep 1;
cd /tmp
curl  -k -Lbk -m 55532 -m 555104 "https://raw.githubusercontent.com/emilnabil/multi-stalkerpro/main/python3-rarfile_4.1-r0_aarch64.ipk" > /tmp/python3-rarfile_4.1-r0_aarch64.ipk
$INSTALL /tmp/python3-rarfile_4.1-r0_aarch64.ipk
sleep 2
rm -f /tmp/python3-rarfile_4.1-r0_aarch64.ipk
echo ""
sleep 1;
cd /tmp
curl  -k -Lbk -m 55532 -m 555104 "https://raw.githubusercontent.com/emilnabil/multi-stalkerpro/main/multi-stalkerpro-py3.12-openvix-openbh_aarch64.ipk" > /tmp/multi-stalkerpro-py3.12-openvix-openbh_aarch64.ipk
$INSTALL /tmp/multi-stalkerpro-py3.12-openvix-openbh_aarch64.ipk
sleep 2
rm -f /tmp/multi-stalkerpro-py3.12-openvix-openbh_aarch64.ipk
echo ""
if [ -e /tmp/MultiStalkerPro.json ]; then
rm -f /etc/enigma2/MultiStalkerPro.json
cp -f /tmp/MultiStalkerPro.json /etc/enigma2/MultiStalkerPro.json
fi
echo ""
elif (grep -qs -i "openbh" /etc/image-version); then
rm -rf "$path"
sleep 1;
cd /tmp
curl  -k -Lbk -m 55532 -m 555104 "https://raw.githubusercontent.com/emilnabil/multi-stalkerpro/main/python3-rarfile_4.1-r0_aarch64.ipk" > /tmp/python3-rarfile_4.1-r0_aarch64.ipk
$INSTALL /tmp/python3-rarfile_4.1-r0_aarch64.ipk
sleep 2
rm -f /tmp/python3-rarfile_4.1-r0_aarch64.ipk
echo ""
sleep 1;
cd /tmp
curl  -k -Lbk -m 55532 -m 555104 "https://raw.githubusercontent.com/emilnabil/multi-stalkerpro/main/multi-stalkerpro-py3.12-openvix-openbh_aarch64.ipk" > /tmp/multi-stalkerpro-py3.12-openvix-openbh_aarch64.ipk
$INSTALL /tmp/multi-stalkerpro-py3.12-openvix-openbh_aarch64.ipk
sleep 2
rm -f /tmp/multi-stalkerpro-py3.12-openvix-openbh_aarch64.ipk
echo ""
if [ -e /tmp/MultiStalkerPro.json ]; then
rm -f /etc/enigma2/MultiStalkerPro.json
cp -f /tmp/MultiStalkerPro.json /etc/enigma2/MultiStalkerPro.json
fi
echo ""
else
echo ""
fi
else
echo ""
sleep 2;
fi
echo ""
wget -q  "--no-check-certificate" https://github.com/emilnabil/multi-stalkerpro/raw/refs/heads/main/icon.png -O /$PLUGINPATH/icon.png
echo "#########################################################"
echo "**                                                                    *"
echo "**                       multi-stalkerpro                     *"
echo "**                                                                    *"
echo "***********************************************************************"
echo "   UPLOADED BY  >>>>   EMIL_NABIL "
sleep 4
exit







