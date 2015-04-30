#!/bin/bash

# Configuration options for building Komodo and its dependencies from source.
# You should not need to change anything in this file - whilst in theory
# later versions of Glib and GTK might work, only 1.2.x have been tested
# as they were 'current' at the time Komodo was developed.

if [ type sudo &> /dev/null ]; then
  export SUDO_CMD=""
else
  export SUDO_CMD="sudo"
fi

export KMD_TMP_DIR="/tmp/komodo"
export GNOME_BASE_URL="http://ftp.gnome.org/pub/gnome/sources/"

export CONFIG_URL="git://git.savannah.gnu.org/config.git"
export CONFIG_SRC_DIR="${KMD_TMP_DIR}/config"

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
