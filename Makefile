#
#
#

PREFIX =	$(HOME)
BINDIR =	$(PREFIX)/bin
MANDIR =	$(PREFIX)/man/man1

P2M_OPTS =	-s 1 -r "Alpha" -c "opam.ocaml.org"

OCB =		ocamlbuild

all:		ago.native ago.1

ago.native:	FORCE
		$(OCB) -libs unix ago.native

clean:		FORCE
		$(OCB) -clean
		rm -f ago.1
		rm -f url

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

# OPAM - the targets below help to publish this code via opam.ocaml.org

VERSION =	v0.1
GITHUB =	https://github.com/lindig/ocaml-ago
ZIP =		$(GITHUB)/archive/$(VERSION).zip

url:		FORCE
		echo	"archive: \"$(ZIP)\"" > url
		echo	"checksum: \"`curl -L $(ZIP)| md5 -q`\"" >> url

# pseudo target

FORCE:;
