srcdir := $(shell pwd)
builddir := $(srcdir)/build

$(builddir)/%.svg : $(srcdir)/%.ink.svg
	inkscape -l $@ $<

$(builddir)/%.png : $(srcdir)/%.ink.svg
	inkscape -e $@ $<

$(builddir)/%.16x16.png : $(srcdir)/%.ink.svg
	inkscape -e $@ -w 16 -h 16 $<

$(builddir)/%.32x32.png : $(srcdir)/%.ink.svg
	inkscape -e $@ -w 32 -h 32 $<

$(builddir)/%.64x64.png : $(srcdir)/%.ink.svg
	inkscape -e $@ -w 64 -h 64 $<

$(builddir)/%.128x128.png : $(srcdir)/%.ink.svg
	inkscape -e $@ -w 128 -h 128 $<

$(builddir)/%.256x256.png : $(srcdir)/%.ink.svg
	inkscape -e $@ -w 256 -h 256 $<

.PHONY: clean
clean :
	rm -r $(builddir)

.PHONY: %.all
%.all : %.svg %.png ;


.PHONY: %.sq.all
%.sq.all : %.all %.16x16.png %.32x32.png %.64x64.png %.128x128.png %.256x256.png ;


$(builddir)/artifacts.zip : $(builddir)/colored_shadow_swatch.sq.all $(builddir)/plain_swatch.sq.all $(builddir)/compact_logo.all $(builddir)/horiz_logo.all
	zip -j $@ $(builddir)/*

.PHONY: all
all : $(builddir)/artifacts.zip
