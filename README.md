# Intel Compute Runtime bundles

This repository provides Intel GPU runtime packages for use in snaps. Choose
the bundle that provides the GPU functionality your application needs:

| Bundle | Provides |
| --- | --- |
| `intel-opencl-icd` | OpenCL ICDs and Intel GPU support libraries, including the components used for GPU detection and vRAM lookup with `clinfo` |
| `intel-compute-runtime` | Intel Graphics Compiler, Level Zero runtime, and `ocloc` |

The `intel-compute-runtime` bundle also includes the OpenCL loader. Bundles are
currently available for amd64 snaps.

## Use without Snapcraft

Run these commands from the repository directory on Ubuntu amd64 with
`make`, Bash, `wget`, `apt-get`, `dpkg`, and `realpath` available:

```sh
make
make install DESTDIR=./dest
```

Omitting `BUNDLE` downloads and installs all bundles. To select a single
bundle, use the same `BUNDLE` value for both commands:

```sh
make BUNDLE=intel-compute-runtime
make install BUNDLE=intel-compute-runtime DESTDIR=./dest
```

Packages are downloaded into `downloads/` by default. The `install` target
also runs the download target, reusing downloaded Intel packages and
refreshing packages from the Ubuntu archive.

`DESTDIR` is required and selects the staging directory for the installed
files, not an installation onto the host system. Run installation as root
inside an isolated Ubuntu amd64 container or build environment; `dpkg`
requires root privileges. Other architectures skip downloading and
installation.

## Use in Snapcraft

Add the make plugin as a part in your `snapcraft.yaml`.
Set `BUNDLE` in `make-parameters` to select one bundle.
If this parameter is omitted, all bundles are installed:

```yaml
parts:
  intel-opencl-icd:
    source: https://github.com/canonical/intel-compute-runtime-bundle.git
    source-tag: <version>
    plugin: make
    make-parameters:
      - BUNDLE=intel-opencl-icd
    build-packages:
      - wget

  intel-compute-runtime:
    source: https://github.com/canonical/intel-compute-runtime-bundle.git
    source-tag: <version>
    plugin: make
    make-parameters:
      - BUNDLE=intel-compute-runtime
    build-packages:
      - wget
    organize:
      "*": (component/openvino-model-server)
```
