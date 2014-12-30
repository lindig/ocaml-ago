#
#
#

PREFIX =    $(HOME)
BINDIR =    $(PREFIX)/bin
MANDIR =    $(PREFIX)/man/man1

OCB =       ocamlbuild

all:        ago.native ago.1

ago.native:	FORCE
		$(OCB) -libs unix ago.native

clean:		FORCE
		$(OCB) -clean
		rm -f ago.1

install:	FORCE
		install -d $(BINDIR)
		install -d $(MANDIR)
		install ago.native $(BINDIR)/ago 

ago.1:		ago.pod
		pod2man $< > $@

FORCE:;
