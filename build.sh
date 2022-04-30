#!/bin/bash

set -u
set -e

source ./config.sh

# Clear out INSTALL PREFIX, or create if it does not exist
if [ -d ${INSTALL_PREFIX} ]; then
  rm -rf ${INSTALL_PREFIX}/*
else
  mkdir ${INSTALL_PREFIX}
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

# Configure glib
cd ${GLIB_SRC_DIR}

# Patch to fix linker issues (multiple definitions)
# taken from this gist: https://gist.github.com/bbidulock/e7ec7d6622471142e248
sed 's,ifdef[[:space:]]*__OPTIMIZE__,if 0,' -i glib.h
./configure ${GLIB_CONFIGURE_OPTIONS[*]}

# Build glib
make
make install

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

# Configure and build GTK
cd ${GTK_SRC_DIR}
./configure ${GTK_CONFIGURE_OPTIONS[*]}
make
make install

# 4. Download and build AASM
# Only download the tarball if it does not exist
if [ ! -f ${AASM_TARBALL} ]; then
  wget ${AASM_URL} -O ${AASM_TARBALL}
fi

# Remove the source directory if it exists
if [ -d ${AASM_SRC_DIR} ]; then
  rm -rf ${AASM_SRC_DIR}
fi

cd ${KMD_TMP_DIR}
unzip ${AASM_TARBALL}

cd ${AASM_SRC_DIR}
${CC} -O2 -o aasm aasm.c
mv aasm ${INSTALL_PREFIX}
mv mnemonics ${INSTALL_PREFIX}

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
unzip ${KMD_TARBALL}

# Copy up to date versions of config files
cp ${CONFIG_SRC_DIR}/config.sub ${KMD_SRC_DIR}/config.sub
cp ${CONFIG_SRC_DIR}/config.guess ${KMD_SRC_DIR}/config.guess

# Set up PATH so it can find GTK config
export PATH="${PATH}:${KMD_TMP_DIR}/bin:${INSTALL_PREFIX}/bin"

# Configure and build Komodo
cd ${KMD_SRC_DIR}
./configure ${KMD_CONFIGURE_OPTIONS[*]}
make

# Horrible hack to get around the problem of OS X refusing to execute
# a script, even if run via /bin/sh install-sh
chmod 755 ${KMD_SRC_DIR}/install-sh

make install

# Create a script for running Komodo
echo "#!/bin/bash" > ${KMD_RUN_SCRIPT}
echo "export LD_LIBRARY_PATH=${INSTALL_PREFIX}" >> ${KMD_RUN_SCRIPT}
echo "export KMD_HOME=${INSTALL_PREFIX}" >> ${KMD_RUN_SCRIPT}
echo "${INSTALL_PREFIX}/bin/kmd \$@" >> ${KMD_RUN_SCRIPT}

chmod 755 ${KMD_RUN_SCRIPT}

# Create the script for running AASM from Komodo
echo "#!/bin/bash" > ${KMD_COMPILE_SCRIPT}
echo 'FLNME=$(echo $1 | sed s/[.]s$//)' >> ${KMD_COMPILE_SCRIPT}
echo "${AASM_BINARY} -lk \${FLNME}.kmd \$1" >> ${KMD_COMPILE_SCRIPT}
