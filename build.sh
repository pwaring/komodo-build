#!/bin/bash

set -u
set -e

export KMD_TMP_DIR="/tmp/komodo"
export KMD_LIB_DIR="/tmp/komodo/libs"

export KMD_FILENAME="kmd.tar.gz"
export KMD_URL="https://studentnet.cs.manchester.ac.uk/resources/software/komodo/${KMD_FILENAME}"

export GNOME_BASE_URL="http://ftp.gnome.org/pub/gnome/sources/"

# Remove and then recrete temp directory
if [ -d ${KMD_TMP_DIR} ]; then
  rm -rf ${KMD_TMP_DIR}
fi

mkdir ${KMD_TMP_DIR}
mkdir ${KMD_LIB_DIR}

# 1. Clone config files so we have up to date versions
export CONFIG_URL="git://git.savannah.gnu.org/config.git"
export CONFIG_SRC_DIR="${KMD_TMP_DIR}/config"

# Only clone the repository if it does not exist on disk
if [ ! -d ${CONFIG_SRC_DIR} ]; then
  cd ${KMD_TMP_DIR}
  git clone ${CONFIG_URL}
fi

# 2. Download and build glib
export GLIB_VERSION_MAJOR="1.2"
export GLIB_VERSION_MINOR="0"
export GLIB_VERSION="${GLIB_VERSION_MAJOR}.${GLIB_VERSION_MINOR}"
export GLIB_FILENAME="glib-${GLIB_VERSION}.tar.gz"
export GLIB_URL="${GNOME_BASE_URL}/glib/${GLIB_VERSION_MAJOR}/${GLIB_FILENAME}"
export GLIB_TARBALL="${KMD_TMP_DIR}/${GLIB_FILENAME}"
export GLIB_SRC_DIR="${KMD_TMP_DIR}/glib-${GLIB_VERSION}"
export GLIB_CONFIGURE_OPTIONS=(
  "--prefix=${KMD_LIB_DIR}"
  "--disable-glibtest"
)

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
make install
