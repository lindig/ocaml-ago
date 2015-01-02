#
#
#

PREFIX =    $(HOME)
BINDIR =    $(PREFIX)/bin
MANDIR =    $(PREFIX)/man/man1

P2M_OPTS =  -s 1 -r "Alpha" -c "opam.ocaml.org"

OCB =       ocamlbuild

all:        ago.native ago.1

ago.native:	FORCE
		$(OCB) -libs unix ago.native

clean:		FORCE
		$(OCB) -clean
		rm -f ago.1

install:	ago.1 ago.native
		install -d $(BINDIR)
		install -d $(MANDIR)
		install ago.native $(BINDIR)/ago
		install ago.1 $(MANDIR)

remove:		FORCE
		rm -f $(BINDIR)/ago
		rm -f $(MANDIR)/ago.1


ago.1:		ago.pod Makefile
		pod2man $(P2M_OPTS) $< > $@

FORCE:;
