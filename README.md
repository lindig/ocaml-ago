
# README

Ago is a small command line utility to compute the number of days between
two calendar dates. If just one date is given, the current date is assumed
for the second one.

    $ ago 2014-12-10 
    -123

    $ ago 2014-10-11 2014-12-04
    -54
    

# BUILDING

Ago is implemented in  OCaml. It does not rely on libraries outside
of the standard library and was developed with OCaml 4.02.1.

    make
    make PREFIX=/usr/local install

# DOCUMENTATION

The ago utility comes with a Unix manual part which is installed by the
install target. It is build from ago.pod in the repository.

# LICENSE

BSD Licencse. See [LICENSE.md](LICENSE.md).

# AUTHOR

Christian Lindig <lindig@gmail.com>




