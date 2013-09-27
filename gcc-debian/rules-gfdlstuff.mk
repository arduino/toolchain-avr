# -*- makefile -*-
# uses information taken from the gcc-4.1 package

gfdl_texinfo_files = \
        gcc/doc/bugreport.texi \
        gcc/doc/cfg.texi \
        gcc/doc/collect2.texi \
        gcc/doc/compat.texi \
        gcc/doc/configfiles.texi \
        gcc/doc/configterms.texi \
        gcc/doc/contrib.texi \
        gcc/doc/contribute.texi \
        gcc/doc/cppenv.texi \
        gcc/doc/cppinternals.texi \
        gcc/doc/cppopts.texi \
        gcc/doc/cpp.texi \
        gcc/doc/c-tree.texi \
        gcc/doc/extend.texi \
        gcc/doc/fragments.texi \
        gcc/doc/frontends.texi \
        gcc/doc/gccint.texi \
        gcc/doc/gcc.texi \
        gcc/doc/gcov.texi \
        gcc/doc/gnu.texi \
        gcc/doc/gty.texi \
        gcc/doc/headerdirs.texi \
        gcc/doc/hostconfig.texi \
        gcc/doc/implement-c.texi \
        gcc/doc/install-old.texi \
        gcc/doc/install.texi \
        gcc/doc/interface.texi \
        gcc/doc/invoke.texi \
        gcc/doc/languages.texi \
        gcc/doc/libgcc.texi \
        gcc/doc/makefile.texi \
        gcc/doc/md.texi \
        gcc/doc/objc.texi \
        gcc/doc/options.texi \
        gcc/doc/passes.texi \
        gcc/doc/portability.texi \
        gcc/doc/rtl.texi \
        gcc/doc/service.texi \
        gcc/doc/sourcebuild.texi \
        gcc/doc/standards.texi \
        gcc/doc/tm.texi \
        gcc/doc/tree-ssa.texi \
        gcc/doc/trouble.texi \
        gcc/doc/include/gcc-common.texi \
        gcc/doc/include/funding.texi \
        libstdc++-v3/docs/html/17_intro/porting.texi \

gfdl_toplevel_texinfo_files = \
        gcc/doc/gcc.texi \
        gcc/treelang/treelang.texi \

gfdl_manpages = \
        gcc/doc/cpp.1 \
        gcc/doc/g++.1 \
        gcc/doc/gcc.1 \
        gcc/doc/gcj.1 \
        gcc/doc/gcj-dbtool.1 \
        gcc/doc/gcjh.1 \
        gcc/doc/gcov.1 \
        gcc/doc/gij.1 \
        gcc/doc/gjnih.1 \
        gcc/doc/grmic.1 \
        gcc/doc/grmiregistry.1 \
        gcc/doc/jcf-dump.1 \
        gcc/doc/jv-convert.1 \
        gcc/doc/jv-scan.1

unpackedpath=build-tree/gcc-4.1.0

repack-gfdl: repack-gfdl-core repack-gfdl-g++

# core
repack-gfdl-core: unpack-core remove-gfdl-core
	(cd core; tar -cjf ../gcc-core-4.1.0.tar.bz2 *)
	rm -rf core

core: unpack-core
unpack-core:
	mkdir core
	(cd core; tar -xjf ../gcc-core-4.1.0.tar.bz2)

remove-gfdl-core: core
	(cd core; $(remove-gfdl))
	rm -rf core/$(unpackedpath)/INSTALL


# g++
repack-gfdl-g++: unpack-g++ remove-gfdl-g++
	(cd g++; tar -cjf ../gcc-g++-4.1.0.tar.bz2 *)
	rm -rf g++

g++: unpack-g++
unpack-g++:
	mkdir g++
	(cd g++; tar -xjf ../gcc-g++-4.1.0.tar.bz2)

remove-gfdl-g++: g++
	(cd g++; $(remove-gfdl))
	rm -rf g++/$(unpackedpath)/INSTALL



define remove-gfdl 
	for file in $(gfdl_texinfo_files) $(gfdl_toplevel_texinfo_files) $(gfdl_manpages); do \
	   rm -f $(unpackedpath)/$$file; \
	done
endef

.PHONY: repack-gfdl
