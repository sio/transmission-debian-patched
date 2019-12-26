# BUILD PATCHED TRANSMISSION PACKAGE FOR DEBIAN

Execute `make` to build Debian package for Transmission with following patches:

- fdlimit.patch - Lift 1024 open files limit (switch to curl polling API)

Resulting '*.deb' packages will be located in `pkg/` directory.

All build steps are executed in Docker, host system is not modified.  Use `make
clean` to remove all build artifacts and all Docker images created in the
process.
