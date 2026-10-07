# Intel Compute Runtime bundles

This repository provides Intel GPU runtime packages for use in snaps. Choose
the bundle that provides the GPU functionality your application needs:

| Bundle | Provides |
| --- | --- |
| `intel-opencl-icd` | OpenCL ICDs and Intel GPU support libraries, including the components used for GPU detection and vRAM lookup with `clinfo` |
| `intel-compute-runtime` | Intel Graphics Compiler, Level Zero runtime, and `ocloc` |

The `intel-compute-runtime` bundle also includes the OpenCL loader. Bundles are
currently available for amd64 snaps.

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
```
