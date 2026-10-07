# Bundle to install: intel-opencl-icd or intel-compute-runtime. Empty installs all.
BUNDLE ?=
ARCH ?= $(if $(CRAFT_ARCH_BUILD_FOR),$(CRAFT_ARCH_BUILD_FOR),$(shell dpkg --print-architecture))
DOWNLOAD_DIR ?= $(CURDIR)/downloads

BUNDLES := $(notdir $(wildcard bundles/*))
SELECTED := $(if $(BUNDLE),$(BUNDLE),$(BUNDLES))

ifneq ($(filter-out $(BUNDLES),$(SELECTED)),)
$(error Unknown BUNDLE "$(BUNDLE)"; valid values are: $(BUNDLES))
endif

# Archive packages are installed first, then legacy packages, so the latest
# packages can override them.
LISTS := $(wildcard $(foreach b,$(SELECTED),bundles/$(b)/archive.packages)) \
	$(foreach b,$(SELECTED),bundles/$(b)/legacy.urls) \
	$(foreach b,$(SELECTED),bundles/$(b)/latest.urls)

.PHONY: all install

ifeq ($(ARCH),amd64)
all:
	scripts/download.sh "$(DOWNLOAD_DIR)" "$(ARCH)" $(LISTS)

install: all
	@test -n "$(DESTDIR)" || { echo "DESTDIR must be set" >&2; exit 1; }
	scripts/install.sh "$(DESTDIR)" "$(DOWNLOAD_DIR)" $(LISTS)
else
all install:
	@echo "Skipping Intel packages for $(ARCH) (amd64 only)"
endif
