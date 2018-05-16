builddir := ./build

.PHONY: all
all : $(builddir)/artifacts.zip \
	$(builddir)/colored_shadow_swatch.sq.all $(builddir)/plain_swatch.sq.all $(builddir)/compact_logo.all $(builddir)/horiz_logo.all ;

$(builddir)/%.svg : %.ink.svg
	inkscape -l $@ $<

$(builddir)/%.png : %.ink.svg
	inkscape -e $@ $<

$(builddir)/%.16x16.png : %.ink.svg
	inkscape -e $@ -w 16 -h 16 $<

$(builddir)/%.32x32.png : %.ink.svg
	inkscape -e $@ -w 32 -h 32 $<

$(builddir)/%.64x64.png : %.ink.svg
	inkscape -e $@ -w 64 -h 64 $<

$(builddir)/%.128x128.png : %.ink.svg
	inkscape -e $@ -w 128 -h 128 $<

$(builddir)/%.256x256.png : %.ink.svg
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

.PHONY: %.upload
%.upload : %
	curl --fail -u ${uploaduser}:${uploadpass} --upload-file $< '${uploadloc}/$(<F)'

.PHONY: %.upload.all
%.upload.all : %.svg.upload %.png.upload ;

.PHONY: %.upload.sq.all
%.upload.sq.all : %.upload.all %.16x16.png.upload %.32x32.png.upload %.64x64.png.upload %.128x128.png.upload %.256x256.png.upload ;

.PHONY: upload.all
upload.all : $(builddir)/artifacts.zip $(builddir)/colored_shadow_swatch.upload.sq.all $(builddir)/plain_swatch.upload.sq.all $(builddir)/compact_logo.upload.all $(builddir)/horiz_logo.upload.all
