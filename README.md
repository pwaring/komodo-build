# Komodo

Build scripts for Komodo.

## Dependencies

### Windows

It is possible to build Komodo on Windows using Cygwin. The following packages
must be installed for a successful build:

 * Libs -> libX11-devel
 * Libs -> libXt-devel
 * X11 -> xinit

## Build options

On Linux and Windows (Cygwin), no extra build options should be necessary,
unless you have installed the dependencies to non-standard locations.

On OS X, you will need to set the following environment variables:

* `CC`: Path to GCC binary. This is required because by default `CC` and the
`gcc` command both point to `clang`, which will not compile Komodo.
* `X_INCLUDES`: Path to X11 includes, likely to be: `/opt/X11/include`
* `X_LIBRARIES`: Path to X11 libraries, likely to be: `/opt/X11/lib`
