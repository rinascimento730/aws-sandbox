#!/bin/bash
# タイムゾーンを日本に変更
sudo cp -p /usr/share/zoneinfo/Japan /etc/localtime

# set install version
PYTHON="3.6"
PYTHON_FULL="3.6.2"

#set PATH
SRC_TO="/usr/local/src"
PYTHON_AT="/opt/local"
PIP_AT="/opt/local"

# yum upgrade
sudo yum -y upgrade

# install dev tools
sudo yum -y groupinstall "Development tools"
sudo rpm -Uvh http://vault.centos.org/6.5/SCL/x86_64/scl-utils/scl-utils-20120927-11.el6.centos.alt.x86_64.rpm
sudo rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
sudo yum -y install git zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel nginx

# install boost-devel
if [ ! -e /etc/yum.repos.d/enetres.repo ]
then
    sudo wget http://repo.enetres.net/enetres.repo -O /etc/yum.repos.d/enetres.repo
    sudo yum -y localinstall http://repo.enetres.net/x86_64/boost-devel-1.59.0-1.x86_64.rpm
fi

# add Devtoolset-3 Repo
if [ ! -e /etc/yum.repos.d/rhscl-devtoolset-3-epel-6.repo ]
then
    cd  /etc/yum.repos.d/
    sudo wget --no-check-certificate https://copr-fe.cloud.fedoraproject.org/coprs/rhscl/devtoolset-3/repo/epel-6/rhscl-devtoolset-3-epel-6.repo
    sudo yum -y install devtoolset-3-gcc devtoolset-3-binutils
    sudo yum -y install devtoolset-3-gcc-c++ devtoolset-3-gcc-gfortran

    #scl enable devtoolset-3 bash
    echo 'source /opt/rh/devtoolset-3/enable' >> ~/.bash_profile
fi

# install MySQL
sudo yum -y install http://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm
sudo yum -y install mysql mysql-devel mysql-server mysql-utilities
sudo chkconfig mysqld on

# install PYTHON
if [ ! -e ${PYTHON_AT}/bin/python${PYTHON} ]
then
    # get PYTHON
    cd ${SRC_TO}
    sudo curl -O https://www.python.org/ftp/python/${PYTHON_FULL}/Python-${PYTHON_FULL}.tgz
    sudo tar zxf Python-${PYTHON_FULL}.tgz

    # install PYTHON
    cd Python-${PYTHON_FULL}
    sudo ./configure --prefix=${PYTHON_AT}
    sudo make && sudo make altinstall
fi

# enable python
if [ ! `echo  $PATH | grep ${PYTHON_AT}'/bin'` ]
then
  echo 'export PATH=$PATH:'${PYTHON_AT}'/bin' >> ~/.bash_profile
  source ~/.bash_profile
fi

# install pip3
if [ ! -e ${PIP_AT}/bin/pip${PYTHON} ]
then
    cd ${SRC_TO}
    # install pip
    sudo curl -O https://bootstrap.pypa.io/get-pip.py
    sudo ${PYTHON_AT}/bin/python${PYTHON} get-pip.py

    #install virtualenv
    sudo ${PIP_AT}/bin/pip${PYTHON} install virtualenv

    # install distribute
    sudo ${PIP_AT}/bin/pip${PYTHON} install -U setuptools
fi

# install beautifulsoup
sudo ${PIP_AT}/bin/pip${PYTHON} install beautifulsoup4

# install scikit-learn
sudo ${PIP_AT}/bin/pip${PYTHON} install scikit-learn

# install matplotlib
sudo ${PIP_AT}/bin/pip${PYTHON} install matplotlib

# install numpy
sudo ${PIP_AT}/bin/pip${PYTHON} install numpy

# install scipy
sudo ${PIP_AT}/bin/pip${PYTHON} install scipy

# install sphinx
sudo ${PIP_AT}/bin/pip${PYTHON} install sphinx

# install pydot
sudo ${PIP_AT}/bin/pip${PYTHON} install pydot

# install nose
sudo ${PIP_AT}/bin/pip${PYTHON} install nose

# install shapely
sudo ${PIP_AT}/bin/pip${PYTHON} install shapely

# install coverage
sudo ${PIP_AT}/bin/pip${PYTHON} install coverage

# install ipython
sudo ${PIP_AT}/bin/pip${PYTHON} install ipython

# install nltk
sudo ${PIP_AT}/bin/pip${PYTHON} install -U nltk

# install pyyaml
sudo ${PIP_AT}/bin/pip${PYTHON} install pyyaml

# install gensim
sudo ${PIP_AT}/bin/pip${PYTHON} install --upgrade gensim

# install jug
sudo ${PIP_AT}/bin/pip${PYTHON} install jug

# install basemap
if [ ! -e ${SRC_TO}/basemap-1.1.0 ]
then
    cd ${SRC_TO}
    # install geos
    sudo wget https://github.com/matplotlib/basemap/archive/v1.1.0.tar.gz
    sudo tar xvf v1.1.0.tar.gz
    cd basemap-1.1.0/geos-3.3.3
    sudo ./configure
    sudo make
    sudo make install

    # install basemap
    cd ../
    sudo ${PIP_AT}/bin/pip${PYTHON} install ./
fi

if [ ! -e ~/.config/matplotlib/ ]
then
    mkdir -p ~/.config/matplotlib/
fi

if [ ! -f ~/.config/matplotlib/matplotlibrc ]
then
    echo "backend : Agg" > ~/.config/matplotlib/matplotlibrc
fi

# Install Japanese fonts
if [ ! -f /usr/share/fonts/ipaexg00102/ipaexg.ttf ]
then
    cd ${SRC_TO}
    sudo wget -O ipafont.zip http://ipafont.ipa.go.jp/old/ipafont/IPAfont00303.php
    sudo wget -O ipaexfont.zip http://ipafont.ipa.go.jp/old/old/old/ipaexg00102.php
    sudo unzip ipafont.zip
    sudo unzip ipaexfont.zip
    sudo mkdir -p /usr/share/fonts/IPAfont00303
    sudo cp IPAfont00303/*.ttf /usr/share/fonts/IPAfont00303
    sudo mkdir -p /usr/share/fonts/ipaexg00102/
    sudo cp ipaexg00102/ipaexg00102/*.ttf /usr/share/fonts/ipaexg00102
    fc-cache -fv
    if [ -f ~/.cache/matplotlib/fontList.py3k.cache ]
    then
        rm ~/.cache/matplotlib/fontList.py3k.cache
    fi
fi

# install tornado
sudo ${PIP_AT}/bin/pip${PYTHON} install tornado

# install supervisor (in python2.7)
sudo pip install supervisor
sudo cp -rf /vagrant/supervisor/* /etc/

if [ ! -f /etc/rc.d/init.d/supervisord ]
then
    sudo cp -f /vagrant/init.d/supervisord /etc/rc.d/init.d/supervisord
    sudo chmod 755 /etc/rc.d/init.d/supervisord
    sudo chkconfig --add supervisord
    sudo service supervisord start
else
    supervisorctl reload
fi

# auto boot Nginx
sudo chkconfig nginx on
sudo cp -f /vagrant/nginx/nginx.conf /etc/nginx/nginx.conf
sudo cp -f /vagrant/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf

sudo service nginx restart

