# Komodo

Build scripts for Komodo.

To build Komodo, edit any settings in `config.sh` and then run `./build.sh`.
The script will download packages, so you must have a working internet
connection for the duration of the build process.

## Dependencies

The method for installing the basic dependencies varies based on platform.

### Linux

On Debian systems, the following packages need to be installed:

 * libxmu-dev
 * libxi-dev
 * libxt-dev

Similar packages may exist on other distributions. If your package manager
allows searching within packages, you can find the relevant ones by searching
for the following files:

 * `X11/Xmu/WinUtil.h`
 * `X11/extensions/XInput.h`
 * `X11/Intrinsic.h`

### Windows

It is possible to build Komodo on Windows using Cygwin (64 bit only). The
following packages must be installed for a successful build:

 * Libs: libX11-devel
 * Libs: libXt-devel
 * X11: xinit

These packages can be installed at the same time as Cygwin, or later by
re-running the setup program (`setup-x86_64.exe`).

### OS X

The X11 dependencies can be met be installing [XQuartz](http://xquartz.macosforge.org/).

## Build options

On Linux and Windows (Cygwin), no extra build options should be necessary,
unless you have installed the dependencies to non-standard locations.

On OS X, you will need to set the following environment variables:

* `CC`: Path to GCC binary. This is required because by default `CC` and the
`gcc` command both point to `clang`, which will not compile Komodo.
* `X_INCLUDES`: Path to X11 includes, likely to be: `/opt/X11/include`
* `X_LIBRARIES`: Path to X11 libraries, likely to be: `/opt/X11/lib`

For example:

```
CC=/usr/local/Cellar/gcc49/4.9.2_1/bin/gcc-4.9  X_INCLUDES=/opt/X11/include X_LIBRARIES=/opt/X11/lib bash -x ./build.sh 2>&1 | tee build.log
```

The build script has been tested with GCC 4.9.2 - version 5.1.0 does not work.

## Running Komodo

To run Komodo locally after building, you need to specify an environment
variable so that the shared Glib and GTK libraries are picked up:

```
LD_LIBRARY_PATH=${HOME}/kmd/lib ${HOME}/kmd/bin/kmd
```

Pass the `-e` option to run Komodo as an emulator. Jimulator should be used by default as it is built as part of Komodo.

Under Cygwin, you will need to run the above through an X server terminal,
as opposed to the standard Cygwin terminal.
