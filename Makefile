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
		rm -f url descr

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

test:		ago.native
		./ago.native -test

# OPAM - the targets below help to publish this code via opam.ocaml.org

VERSION =	0.3
TAG =		v$(VERSION)
GITHUB =	https://github.com/lindig/ocaml-ago
ZIP =		$(GITHUB)/archive/$(TAG).zip
OPAM =		$(HOME)/Development/opam-repository/packages/ago/ago.$(VERSION)

descr:		README.md Makefile
		sed -n '/^ago(1)/,$$p'  $< > $@

url:		FORCE
		echo	"archive: \"$(ZIP)\"" > url
		echo	"checksum: \"`curl -L $(ZIP)| md5 -q`\"" >> url

release:	url opam descr
		test -d "$(OPAM)" || mkdir -p $(OPAM)
		cp opam url descr $(OPAM)




# pseudo target

FORCE:;
