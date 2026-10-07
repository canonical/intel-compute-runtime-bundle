# Updating Intel Compute Runtime packages

This project provides Intel GPU runtime packages for use in snaps.

To update to a new upstream release:

1. Read the release notes at
   https://github.com/intel/compute-runtime/releases for the requested version,
   or the latest release if none is specified.
2. Find the amd64 `.deb` download URLs in the release's installation
   instructions. Use the exact dependency versions specified there, including
   Intel Graphics Compiler (IGC) and GMM. Do not independently select newer
   dependencies or construct URLs by replacing version strings.
3. Update the following lists with those URLs, one plain URL per line:

| File | Packages |
| --- | --- |
| `bundles/intel-opencl-icd/latest.urls` | `intel-opencl-icd`, `libigdgmm12` |
| `bundles/intel-compute-runtime/latest.urls` | `intel-igc-core-2`, `intel-igc-opencl-2`, `intel-ocloc`, `libze-intel-gpu1` |

Exclude debug-symbol packages and other architectures. Keep unchanged
dependency URLs as they are. If a required package is missing or renamed,
report it rather than guessing a replacement.

Leave `legacy.urls` and `archive.packages` unchanged unless explicitly asked
to update them. Legacy packages use a separate upstream release line and its
own dependency versions. See upstream's
[legacy platform documentation](https://github.com/intel/compute-runtime/blob/master/documentation/LEGACY_PLATFORMS.md)
for the applicable release line and supported platforms.
