include guile.am

moddir=$(prefix)/share/guile/site/$(GUILE_EFFECTIVE_VERSION)
godir=$(libdir)/guile/$(GUILE_EFFECTIVE_VERSION)/site-ccache

SOURCES = \
	irc/channel.scm \
	irc/error.scm \
	irc/error-code.scm \
	irc/message.scm \
	irc/tagged-hook.scm \
	irc/irc.scm \
	irc/handlers.scm
if GNUTLS
SOURCES += \
	irc/gnutls.scm \
	irc/network.scm
else
SOURCES += 
endif

info_TEXINFOS = doc/api.texi

TEST_EXTENSIONS = .scm
SCM_TESTS = \
	test/message-test.scm

TESTS = $(SCM_TESTS)

AM_TESTS_ENVIRONMENT = abs_top_srcdir="$(abs_top_srcdir)" GUILE_AUTO_COMPILE=0

SCM_LOG_DRIVER =                                          \
  $(top_builddir)/env                                     \
  $(GUILE) --no-auto-compile -e main                      \
      $(top_srcdir)/build-aux/test-driver.scm

AM_SCM_LOG_DRIVER_FLAGS = --brief=yes

EXTRA_DIST += $(TESTS) $(info_TEXINFOS)
