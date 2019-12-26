# Build transmission package for Debian after applying patches

## Usage

Execute `make` to build Debian package for Transmission with following patches:

- fdlimit.patch - Lift 1024 open files limit (switch to curl polling API)

Resulting `*.deb` packages will be located in `pkg/` directory.

All build steps are executed in Docker, host system is not modified.
Use `make clean` to remove all build artifacts and all Docker images created
in the process.


## Requirements (host system)

- GNU Make
- Docker >= 18.04
- libseccomp >= 2.3.3 (will fail with Qt \*.png build errors otherwise:
  <https://stackoverflow.com/a/52084936>)
- Storage: 2GB (Docker image for build stage is ~1.4GB)


## License and copyright

Copyright 2019 Vitaly Potyarkin

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
