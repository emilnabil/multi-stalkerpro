#!/bin/bash
####
#wget -q "--no-check-certificate" https://raw.githubusercontent.com/emilnabil/multi-stalkerpro/main/installer.sh -O - | /bin/sh

##########################################
echo " DOWNLOAD AND INSTALL 
multi-stalkerpro "
versions="1.0"
TMPDIR='/tmp'
PLUGINPATH='/usr/lib/enigma2/python/Plugins/Extensions/MultiStalkerPro'
SETTINGS='/etc/enigma2/settings'
URL='https://raw.githubusercontent.com/emilnabil/multi-stalkerpro/main'
PYTHON_VERSION=$(python -c"import platform; print(platform.python_version())")
if [ -f /etc/apt/apt.conf ] ; then
STATUS='/var/lib/dpkg/status'
OS='DreamOS'
elif [ -f /etc/opkg/opkg.conf ] ; then
STATUS='/var/lib/opkg/status'
OS='Opensource'
fi
echo " Remove Old Package "
rm -rf /usr/lib/enigma2/python/Plugins/Extensions/MultiStalkerPro > /dev/null 2>&1
rm -rf /etc/enigma2/MultiStalkerPro.json > /dev/null 2>&1
rm -rf /usr/lib/enigma2/python/Components/Converter/MultiStalkerAudioInfo* > /dev/null 2>&1
rm -rf /usr/lib/enigma2/python/Components/Converter/MultiStalkerProServicePosition* > /dev/null 2>&1
rm -rf /usr/lib/enigma2/python/Components/Converter/MultiStalkerProServiceResolution* > /dev/null 2>&1
rm -rf /usr/lib/enigma2/python/Components/Renderer/MultiStalkerAudioIcon* > /dev/null 2>&1
rm -rf /usr/lib/enigma2/python/Components/Renderer/MultiStalkerProRunningText* > /dev/null 2>&1
rm -rf /usr/lib/enigma2/python/Components/Renderer/MultiStalkerProStars* > /dev/null 2>&1
echo "Old Package removed "

if [ "$PYTHON_VERSION" == 3.11.0 -o "$PYTHON_VERSION" == 3.11.1 -o "$PYTHON_VERSION" == 3.11.2 -o "$PYTHON_VERSION" == 3.11.3 -o "$PYTHON_VERSION" == 3.11.4 -o "$PYTHON_VERSION" == 3.11.5 ]; then
    echo ":You have $PYTHON_VERSION image ..."
    PYTHONLASTV='PY3'
    IMAGING='python3-imaging'
    PYSIX='python3-six'
elif [ "$PYTHON_VERSION" == 3.12.0 -o "$PYTHON_VERSION" == 3.12.1 -o "$PYTHON_VERSION" == 3.12.2 -o "$PYTHON_VERSION" == 3.12.3 -o "$PYTHON_VERSION" == 3.12.4 -o "$PYTHON_VERSION" == 3.12.5 ]; then
  echo ":You have $PYTHON_VERSION image ..."
PYTHONLASTER='PY3'
     IMAGING='python3-imaging'
    PYSIX='python3-six'
elif [ "$PYTHON_VERSION" == 2.7.18 ]; then
  echo ":You have $PYTHON_VERSION image ..."
    PYTHON='PY2'
    IMAGING='python-imaging'
    PYSIX='python-six'         
else
echo "Python is not supported"
sleep 4;
exit 1
fi
if grep -q $IMAGING $STATUS; then
imaging='Installed'
fi
if grep -q $PYSIX $STATUS; then
six='Installed'
fi
if [ "$imaging" = "Installed" -a "$six" = "Installed" ]; then
echo "All dependecies are installed"
else
if [ $OS = "Opensource" ]; then
echo "=========================================================================="
echo "Some Depends Need to Be downloaded From Feeds ...."
echo "=========================================================================="
echo "Opkg Update ..."
sleep 2;
echo "========================================================================"
opkg update
echo "========================================================================"
echo " Downloading $IMAGING , $PYSIX ......"
opkg install $IMAGING
echo "========================================================================"
opkg install $PYSIX
echo "========================================================================"
else
echo "=========================================================================="
echo "Some Depends Need to Be downloaded From Feeds ...."
echo "=========================================================================="
echo "apt Update ..."
echo "========================================================================"
apt-get update
echo "========================================================================"
echo " Downloading $IMAGING , $PYSIX ......"
apt-get install $IMAGING -y
echo "========================================================================"
apt-get install $PYSIX -y
echo "========================================================================"
fi
fi
if grep -q $IMAGING $STATUS; then
echo ""
else
echo "#########################################################"
echo "#       $IMAGING Not found in feed                      #"
echo "#########################################################"
fi
if grep -q $PYSIX $STATUS; then
echo ""
else
echo "#########################################################"
echo "#       $PYSIX Not found in feed                        #"
echo "#########################################################"
exit 1
fi
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

else
echo "Python is not supported"
sleep 4;
fi

elif grep -qs -i 'armv7l' cat $CHECK ; then
echo "[ Your device is armv7l ]"
if [ "$PYTHONLASTV" = "PY3" ]; then
wget -q  "--no-check-certificate" https://raw.githubusercontent.com/emilnabil/multi-stalkerpro/main/multi-stalkerpro-py3.11_arm.tar.gz -O /tmp/multi-stalkerpro-py3.11_arm.tar.gz
tar -xzf /tmp/multi-stalkerpro-py3.11_arm.tar.gz -C /
sleep 2;
rm -f /tmp/multi-stalkerpro-py3.11_arm.tar.gz

elif [ "$PYTHONLASTER" = "PY3" ]; then
wget -q  "--no-check-certificate" https://raw.githubusercontent.com/emilnabil/multi-stalkerpro/main/multi-stalkerpro-py3.12_arm.ipk -O /tmp/multi-stalkerpro-py3.12_arm.ipk
opkg install /tmp/multi-stalkerpro-py3.12_arm.ipk
sleep 2;
rm -f /tmp/multi-stalkerpro-py3.12_arm.ipk

elif [ "$PYTHON" = "PY2" ]; then
wget -q  "--no-check-certificate" https://raw.githubusercontent.com/emilnabil/multi-stalkerpro/main/multi-stalkerpro-py2.7_arm.tar.gz -O /tmp/multi-stalkerpro-py2.7_arm.tar.gz
tar -xzf /tmp/multi-stalkerpro-py2.7_arm.tar.gz -C /
sleep 2;
rm -f /tmp/multi-stalkerpro-py2.7_arm.tar.gz
else
echo "Python is not supported"
fi
else
echo "Your device is not supported"
sleep 4;
exit 1
fi
echo ""
echo "#########################################################"

echo ""
echo "***********************************************************************"
echo "**                                                                    *"
echo "**                       multi-stalkerpro                     *"
echo "**                                                                    *"
echo "***********************************************************************"
echo "restarting stb"
reboot
exit 0








