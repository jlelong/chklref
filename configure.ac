AC_INIT(chklref,2.5.2, jerome.lelong@gmail.com)

AC_PROG_INSTALL

AC_ARG_WITH(texmf-prefix,
            [  --with-texmf-prefix     prefix to use for texmf [[prefix/share/texmf]]],
            [with_texmf_prefix=$withval])
AC_ARG_WITH(perl,
            [  --with-perl             the perl interpreter to use],
            [with_perl=$withval])

if test "x$prefix" = "xNONE" ; then
    prefix=/usr/local
fi

if test "x$with_texmf_prefix" != "x" ; then
    texmf_prefix=$with_texmf_prefix
else
    texmf_prefix=$prefix/share/texmf
fi
if test -z "$texmf_prefix"; then
    AC_MSG_ERROR("The specified TEXMF directory $texmf_prefix does not exist.
Consider calling configure with the --with-texmf-prefix option")
fi
    

bindir=$prefix/bin
LATEXDIR=$texmf_prefix/tex/latex/$PKGNAME
DOCDIR=$texmf_prefix/doc/latex/$PKGNAME
SCRIPTSDIR=$texmf_prefix/scripts/$PKGNAME

AC_SUBST([PKGNAME], ['AC_PACKAGE_NAME'])
AC_SUBST([VERSION], ['AC_PACKAGE_VERSION'])
AC_SUBST([PREFIX], ['prefix'])
AC_SUBST(bindir)
AC_SUBST(LATEXDIR)
AC_SUBST(DOCDIR)
AC_SUBST(SCRIPTSDIR)

# latex
AC_PATH_PROG(LATEX_PATH, latex)
if test "x$LATEX_PATH" = "x" ; then 
    AC_MSG_ERROR("latex command was not found")
fi
AC_SUBST(LATEX_PATH)

# pdflatex
AC_PATH_PROG(PDFLATEX_PATH, pdflatex)
if test "x$PDFLATEX_PATH" = "x" ; then
    AC_MSG_ERROR("pdflatex command was not found")
fi
AC_SUBST(PDFLATEX_PATH)

# perl
if test "x$with_perl" != "x" ; then
    if test -f "$with_perl"; then
        PERL_PATH="$with_perl"
    else
        PERL_PATH=""
    fi
fi
if test "x$PERL_PATH" = "x"; then
    AC_PATH_PROG(PERL_PATH, perl)
fi
if test "x$PERL_PATH" = "x" ; then 
    AC_MSG_ERROR("perl command was not found")
fi
AC_SUBST(PERL_PATH)

AC_OUTPUT(Make.incl
          doc/Makefile 
          src/Makefile 
          src/chklref
          VERSION)

AC_MSG_NOTICE(
[
** Summary **
   texm_prefix         $texmf_prefix
   bindir              $bindir
   perl interpreter    $PERL_PATH 

   Run make and make install ])
