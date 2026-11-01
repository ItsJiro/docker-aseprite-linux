# Docker Aseprite Builder


**This repository is a fork of docker-aseprite-linux, originally created by nilsve.**

All credit for the original project goes to nilsve. My contribution is a modification to the original build process: instead of compiling Skia from source, this fork downloads and uses a precompiled Skia release. This significantly reduces build time and avoids the need to download and compile the large Skia source tree.



## Versions

The build currently uses:

- **Aseprite:** `v1.3.18.6`
- **Skia:** `m124` (precompiled Linux x64 release)

You can change the versions in `compile.sh` if you want to build a different release.

## Usage

1. Install [Docker](https://docs.docker.com/engine/install/).
2. Clone this repository:

   ```bash
   git clone https://github.com/ItsJiro/docker-aseprite-linux.git
   ```

3. Navigate into the cloned repository:

   ```bash
   cd docker-aseprite-linux
   ```

4. Build Aseprite:

   ```bash
   make build
   ```

   Alternatively, you can use Docker Compose:

   ```bash
   make build-compose
   ```

5. Wait for the build to finish.

Once completed, the compiled Aseprite files will be available in:

```text
output/aseprite/build/bin/
```

The executable is located at:

```text
output/aseprite/build/bin/aseprite
```

## Installing Aseprite locally

You can copy the compiled application into your local applications directory so it can be launched without keeping the build output in the repository.

```bash
mkdir -p ~/.local/opt/aseprite

cp -a output/aseprite/build/bin/. ~/.local/opt/aseprite/
```

You can now launch Aseprite using:

```bash
~/.local/opt/aseprite/aseprite
```

### Adding Aseprite to your application launcher

Create a desktop entry:

```bash
mkdir -p ~/.local/share/applications

cat > ~/.local/share/applications/aseprite.desktop <<EOF
[Desktop Entry]
Name=Aseprite
Comment=Animated sprite editor
Exec=$HOME/.local/opt/aseprite/aseprite %F
Icon=$HOME/.local/opt/aseprite/data/icons/ase256.png
Terminal=false
Type=Application
Categories=Graphics;2DGraphics;RasterGraphics;
StartupNotify=true
EOF
```

Aseprite should now appear in application launchers such as Rofi:

```bash
rofi -show drun
```

## Rebuilding

If you want to perform a fresh build, remove the existing build output before running the build command again:

```bash
rm -rf output/aseprite
```

The Docker image can also be rebuilt without using cached layers:

```bash
docker build --no-cache -t docker-aseprite .
```

## FAQ

### Docker permission denied

If you get a Docker socket permission error when running `make build`, add your user to the Docker group:

```bash
sudo usermod -aG docker "$USER"
```

Log out and back in for the group change to take effect.

Alternatively, you can run Docker commands with `sudo`.

### Missing shared libraries

If Aseprite fails to launch with an error similar to:

```text
error while loading shared libraries: libdeflate.so.0: cannot open shared object file
```

You are missing a runtime library required by Aseprite.

On Ubuntu, install the required library with:

```bash
sudo apt install libdeflate0
```

On Arch Linux, install:

```bash
sudo pacman -S libdeflate
```

### Missing OpenSSL 1.1 library

If you encounter:

```text
error while loading shared libraries: libcrypto.so.1.1: cannot open shared object file
```

Aseprite may require the OpenSSL 1.1 compatibility library, which is not included with newer OpenSSL 3 installations.

You will need to install a compatible OpenSSL 1.1 library for your distribution. Package availability and installation methods vary by distribution.

## License

MIT License

Copyright (c) 2025 nilsve

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
