# intel-compute-runtime-bundle

This repository provides two standalone makefiles for installing a pinned
combination of Intel GPU packages:

| Makefile | Packages |
| --- | --- |
| `Makefile.icd` | Legacy and current OpenCL ICDs, plus libigdgmm, for Intel GPU vRAM lookup with clinfo |
| `Makefile.compute-runtime` | Legacy and current Intel Graphics Compiler and Level Zero libraries, plus current ocloc |

Both install legacy packages before current packages so current libraries can
override old ones. The ICD makefile also removes the unused absolute ocloc
symlinks created by the legacy package, which otherwise fail snap store review.
Both makefiles skip downloads and installation for architectures other than amd64.

## Updating packages

Find the desired release at
[Intel compute runtime releases](https://github.com/intel/compute-runtime/releases).
Copy the relevant lines from its wget example, remove the `wget` prefix, and
paste one full URL per line into each makefile's `LATEST_URLS` block, between
`define LATEST_URLS` and `endef`. No quotes or trailing backslashes are needed.
Keep the ICD and libigdgmm URLs in `Makefile.icd`, and the compiler, Level Zero,
and ocloc URLs in `Makefile.compute-runtime`.

The `LEGACY_URLS` blocks use the same format and can be updated independently
when needed for older GPU support. Filenames and download/install lists are
derived from these URLs; there are no separate version variables to update.

## Usage

Requires GNU Make, wget, and dpkg. The default target (`all`, also available as
`download`) downloads packages without installing them. `install` downloads any
missing packages and installs them into the required `DESTDIR`:

```sh
make -f Makefile.icd install ARCH=amd64 DESTDIR=/path/to/install
make -f Makefile.compute-runtime install ARCH=amd64 DESTDIR=/path/to/install
```

`ARCH` defaults to `CRAFT_ARCH_BUILD_FOR`, or the host's dpkg architecture outside
Snapcraft. `DESTDIR` defaults to `CRAFT_PART_INSTALL`. Downloads are cached under
`CRAFT_PART_BUILD/icd` and `CRAFT_PART_BUILD/compute-runtime`, respectively, or
under `.build/` outside Snapcraft. Override `BUILD_DIR` to change a makefile's
download directory. Installation uses `dpkg --force-all`, matching the original
Snapcraft blocks; the destination is a package staging root, not the host system.

## Snapcraft integration

With the repository available in `CRAFT_PART_SRC`, replace the ICD part's
`override-build` with:

```yaml
override-build: |
  make -C "$CRAFT_PART_SRC" -f Makefile.icd install
  craftctl default
```

Replace the compute runtime part's `override-build` with:

```yaml
override-build: |
  make -C "$CRAFT_PART_SRC" -f Makefile.compute-runtime install
  craftctl default
```

Keep `plugin: nil` and include `make` and `wget` in each part's `build-packages`.
Keep the compute runtime part's amd64-only `ocl-icd-libopencl1` stage package and
its `organize` mapping to `(component/openvino-model-server)` in Snapcraft. These
handle the distribution's OpenCL loader and the final component layout; neither
is managed by the makefiles.
