#!/usr/bin/make -f
# Separate tarball/patch build system by Adam Heath <doogie@debian.org>
# Modified by Ben Collins <bcollins@debian.org>
#
# Usage in debian/rules - see dbs(7) man page for the full description
# 
SOURCE_DIR	= build-tree
STAMP_DIR	= stampdir
## PATCH_DIR	= debian/patches # set this in debian/vars
## SRC_TAR_DIR	= .

# include debian/vars if it exists
# this allows to override the above variables
ifneq (,$(wildcard debian/vars))
  include debian/vars
  debian_vars	= debian/vars
else  
  debian_vars	=
endif  

SHELL		= /bin/bash -e
DBS_SCRIPT_DIR	= /usr/share/dbs
DBS_SPLIT	= $(DBS_SCRIPT_DIR)/dbs_split
DBS_FILE2CAT	= $(DBS_SCRIPT_DIR)/internal/file2cat
DBS_LIB		= $(DBS_SCRIPT_DIR)/internal/lib
DBS_VARSBUILD	= $(DBS_SCRIPT_DIR)/internal/vars.build


unexport CDPATH ENV
patched		= $(STAMP_DIR)/patchapply
unpacked	= $(STAMP_DIR)/source.unpack
created		= $(STAMP_DIR)/source.created
sh_vars		= $(STAMP_DIR)/vars.sh
DBS_LIB		+= "SOURCE_DIR=\"$(SOURCE_DIR)\""
DBS_LIB		+= "STAMP_DIR=\"$(STAMP_DIR)\""
DBS_LIB		+= "VARS_FILE=\"$(sh_vars)\""
DBS_LIB		+= "STRIP_LEVEL=0"

ifdef TAR_DIR
  BUILD_TREE	= $(SOURCE_DIR)/$(TAR_DIR)
  DBS_LIB	+= "TAR_DIR=\"$(TAR_DIR)\""
else
  BUILD_TREE	= $(SOURCE_DIR)
endif

# for backward compatibility (used by pgp4pine)
ifeq (,$(SCRIPT_DIR))
SCRIPT_DIR	= $(DBS_SCRIPT_DIR)/internal/
$(STAMP_DIR)/created: $(created)
	touch "$@"
endif


dh_mak_deps = $(shell DH_COMPAT=$(DH_COMPAT) perl $(DBS_SPLIT) makedeps)
dh_gen_deps = $(shell DH_COMPAT=$(DH_COMPAT) perl $(DBS_SPLIT) gendeps)

$(dh_mak_deps): $(dh_gen_deps)
	perl $(DBS_SPLIT)


setup: $(dh_mak_deps)
	dh_testdir
	@-up-scripts
	$(MAKE) -f debian/rules $(unpacked) $(patched)

$(patched)/: $(created) $(sh_vars) $(unpacked)
	$(SHELL) $(DBS_LIB) patch_apply
	touch "$@"

unpacked: $(unpacked)
$(unpacked): $(created) $(sh_vars)
	$(SHELL) $(DBS_LIB) source_unpack
	touch "$@"

make_patch:
	mv $(SOURCE_DIR) $(SOURCE_DIR).new
	rm -rf $(STAMP_DIR)
	$(MAKE) -f debian/rules $(unpacked) $(patched)
	mv $(SOURCE_DIR) $(SOURCE_DIR).old
	mv $(SOURCE_DIR).new $(SOURCE_DIR)
	(cd $(SOURCE_DIR) && diff -Nru ../$(SOURCE_DIR).old ./ || test $$? -eq 1 && exit 0) > new.diff
	rm -rf $(SOURCE_DIR).old
	@echo; ls -l new.diff

$(created): 
	test -d $(STAMP_DIR) || mkdir $(STAMP_DIR)
	touch "$@"

$(sh_vars): $(debian_vars) $(created)
ifneq (,$(debian_vars))
	$(SHELL)  $(DBS_VARSBUILD) "$(debian_vars)" shell > "$@"
endif
	touch "$@"
