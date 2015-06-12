# Komodo

Build scripts for Komodo.

To build Komodo, edit any settings in `config.sh` and then run `./build.sh`.

## Dependencies

### Windows

It is possible to build Komodo on Windows using Cygwin. The following packages
must be installed for a successful build:

 * Libs -> libX11-devel
 * Libs -> libXt-devel
 * X11 -> xinit

These packages can be installed at the same time as Cygwin, or later by
re-running the setup program (`setup-x86.exe` or `setup-x86_64.exe`).

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

## Running Komodo

To run Komodo locally after building, you need to specify an environment
variable so that the shared Glib and GTK libraries are picked up:

```
LD_LIBRARY_PATH=${HOME}/kmd ${HOME}/kmd/bin/kmd
```

Under Cygwin, you will need to run the above through an X server terminal,
as opposed to the standard Cygwin terminal.
