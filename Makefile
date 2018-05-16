builddir := ./build

.PHONY: all
all : $(builddir)/artifacts.zip \
	$(builddir)/colored_shadow_swatch.sq.all $(builddir)/plain_swatch.sq.all $(builddir)/compact_logo.all $(builddir)/horiz_logo.all ;

.PHONY: clean
clean :
	rm -r $(builddir)

i_exec := inkscape
i_flags := -z

inkscape = $(i_exec) $(i_flags)

sizes := 16 32 64 128 256 512

$(builddir)/%.svg : %.ink.svg
	$(inkscape) -l $@ $<

$(builddir)/%.png : %.ink.svg
	$(inkscape) -e $@ $<

define SIZED_PNG_GEN

$(builddir)/%.$(1)x$(1).png : %.ink.svg
	$(inkscape) -e $$@ -w $(1) -h $(1) $$<

endef
$(foreach size,$(sizes),$(eval $(call SIZED_PNG_GEN,$(size))))

.PHONY: %.all
%.all : %.svg %.png ;

.PHONY: %.sq.all
%.sq.all : %.all $(foreach size,$(sizes),%.$(size)x$(size).png) ;

$(builddir)/artifacts.zip : $(builddir)/colored_shadow_swatch.sq.all $(builddir)/plain_swatch.sq.all $(builddir)/compact_logo.all $(builddir)/horiz_logo.all
	zip -j $@ $(builddir)/*

.PHONY: %.upload
%.upload : %
	curl --fail -n --upload-file $< '${uploadloc}/$(<F)'

.PHONY: %.upload.all
%.upload.all : %.svg.upload %.png.upload ;

.PHONY: %.upload.sq.all
%.upload.sq.all : %.upload.all $(foreach size,$(sizes),%.$(size)x$(size).png.upload) ;

.PHONY: upload.all
upload.all : $(builddir)/artifacts.zip $(builddir)/colored_shadow_swatch.upload.sq.all $(builddir)/plain_swatch.upload.sq.all $(builddir)/compact_logo.upload.all $(builddir)/horiz_logo.upload.all
