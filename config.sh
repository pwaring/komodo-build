#!/bin/bash

# Configuration options for building Komodo and its dependencies from source.
# You should not need to change anything in this file - whilst in theory
# later versions of Glib and GTK might work, only 1.2.x have been tested
# as they were 'current' at the time Komodo was developed.
export INSTALL_PREFIX="${HOME}/kmd"
export X_INCLUDES=${X_INCLUDES:-}
export X_LIBRARIES=${X_LIBRARIES:-}

export KMD_TMP_DIR="${HOME}/kmd/tmp"
export GNOME_BASE_URL="http://ftp.gnome.org/pub/gnome/sources/"

export CONFIG_URL="git://git.savannah.gnu.org/config.git"
export CONFIG_SRC_DIR="${KMD_TMP_DIR}/config"

export GENERAL_CONFIGURE_OPTIONS=(
  "--prefix=${INSTALL_PREFIX}"
)

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

GLIB_CONFIGURE_OPTIONS+=(${GENERAL_CONFIGURE_OPTIONS[*]})

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

# Specify X includes and libraries if necessary, e.g. on OS X
if [ ! -z ${X_INCLUDES} ]; then
  GTK_CONFIGURE_OPTIONS+=("--x-includes=${X_INCLUDES}")
fi

if [ ! -z ${X_LIBRARIES} ]; then
  GTK_CONFIGURE_OPTIONS+=("--x-libraries=${X_LIBRARIES}")
fi

GTK_CONFIGURE_OPTIONS+=(${GENERAL_CONFIGURE_OPTIONS[*]})

export KMD_VERSION="master"
export KMD_FILENAME="master.zip"
export KMD_URL="https://github.com/UoMCS/komodo/archive/${KMD_FILENAME}"
export KMD_TARBALL="${KMD_TMP_DIR}/${KMD_FILENAME}"
export KMD_SRC_DIR="${KMD_TMP_DIR}/komodo-${KMD_VERSION}"
export KMD_CONFIGURE_OPTIONS=(
  "--disable-glibtest"
  "--disable-gtktest"
  "--with-glib=${GLIB_SRC_DIR}"
)

KMD_CONFIGURE_OPTIONS+=(${GENERAL_CONFIGURE_OPTIONS[*]})
