#!/bin/bash

set -u
set -e

export KMD_TMP_DIR="/tmp/komodo"

export GNOME_BASE_URL="http://ftp.gnome.org/pub/gnome/sources/"

# Remove and then recreate temporary directory
if [ -d ${KMD_TMP_DIR} ]; then
  rm -rf ${KMD_TMP_DIR}
fi

mkdir ${KMD_TMP_DIR}

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
sudo make install

# 3. Download and build GTK
export GTK_VERSION_MAJOR="1.2"
export GTK_VERSION_MINOR="10"
export GTK_VERSION="${GTK_VERSION_MAJOR}.${GTK_VERSION_MINOR}"
export GTK_FILENAME="gtk+-${GTK_VERSION}.tar.gz"
export GTK_URL="${GNOME_BASE_URL}/gtk+/${GTK_VERSION_MAJOR}/${GTK_FILENAME}"
export GTK_TARBALL="${KMD_TMP_DIR}/${GTK_FILENAME}"
export GTK_SRC_DIR="${KMD_TMP_DIR}/gtk+-${GTK_VERSION}"
export GTK_CONFIGURE_OPTIONS=(
  "--disable-glibtest"
  "--disable-gtktest"
  "--with-glib=${GLIB_SRC_DIR}"
)

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
export KMD_VERSION="1.5.0"
export KMD_FILENAME="kmd.tar.gz"
export KMD_URL="https://studentnet.cs.manchester.ac.uk/resources/software/komodo/${KMD_FILENAME}"
export KMD_TARBALL="${KMD_TMP_DIR}/${KMD_FILENAME}"
export KMD_SRC_DIR="${KMD_TMP_DIR}/KMD-${KMD_VERSION}"
export KMD_CONFIGURE_OPTIONS=(
  "--disable-glibtest"
  "--disable-gtktest"
  "--with-glib=${GLIB_SRC_DIR}"
)

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
