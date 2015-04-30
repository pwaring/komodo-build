#!/bin/bash

set -u
set -e

source ./config.sh

# Remove and then recreate temporary directory
if [ -d ${KMD_TMP_DIR} ]; then
  rm -rf ${KMD_TMP_DIR}
fi

mkdir ${KMD_TMP_DIR}

# 1. Clone config files so we have up to date versions
# Only clone the repository if it does not exist on disk
if [ ! -d ${CONFIG_SRC_DIR} ]; then
  cd ${KMD_TMP_DIR}
  git clone ${CONFIG_URL}
fi

# 2. Download and build glib
# Only download the tarball if it does not exist
if [ ! -f ${GLIB_TARBALL} ]; then
  wget ${GLIB_URL} -O ${GLIB_TARBALL}
fi

# Remove the source directory if it exists
if [ -d ${GLIB_SRC_DIR} ]; then
  rm -rf ${GLIB_SRC_DIR}
fi

cd ${KMD_TMP_DIR}
tar xf ${GLIB_TARBALL}

# Copy up to date versions of config files
cp ${CONFIG_SRC_DIR}/config.sub ${GLIB_SRC_DIR}/config.sub
cp ${CONFIG_SRC_DIR}/config.guess ${GLIB_SRC_DIR}/config.guess

# Configure and build glib
cd ${GLIB_SRC_DIR}
./configure ${GLIB_CONFIGURE_OPTIONS[*]}
make
sudo make install

# 3. Download and build GTK
# Only download the tarball if it does not exist
if [ ! -f ${GTK_TARBALL} ]; then
  wget ${GTK_URL} -O ${GTK_TARBALL}
fi

# Remove the source directory if it exists
if [ -d ${GTK_SRC_DIR} ]; then
  rm -rf ${GTK_SRC_DIR}
fi

cd ${KMD_TMP_DIR}
tar xf ${GTK_TARBALL}

# Copy up to date versions of config files
cp ${CONFIG_SRC_DIR}/config.sub ${GTK_SRC_DIR}/config.sub
cp ${CONFIG_SRC_DIR}/config.guess ${GTK_SRC_DIR}/config.guess

# Configure and build glib
cd ${GTK_SRC_DIR}
./configure ${GTK_CONFIGURE_OPTIONS[*]}
make
sudo make install

# 4. Download and build Komodo
# Only download the tarball if it does not exist
if [ ! -f ${KMD_TARBALL} ]; then
  wget ${KMD_URL} -O ${KMD_TARBALL}
fi

# Remove the source directory if it exists
if [ -d ${KMD_SRC_DIR} ]; then
  rm -rf ${KMD_SRC_DIR}
fi

cd ${KMD_TMP_DIR}
tar xf ${KMD_TARBALL}

# Copy up to date versions of config files
cp ${CONFIG_SRC_DIR}/config.sub ${KMD_SRC_DIR}/config.sub
cp ${CONFIG_SRC_DIR}/config.guess ${KMD_SRC_DIR}/config.guess

# Set up PATH so it can find GTK config
export PATH="${PATH}:${KMD_TMP_DIR}/bin"

# Configure and build glib
cd ${KMD_SRC_DIR}
./configure ${KMD_CONFIGURE_OPTIONS[*]}
make
sudo make install
