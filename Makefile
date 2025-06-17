BIN=/usr/local/bin
MAN=/usr/share/man/man1
TARG=9pfs
OBJS=9pfs.o\
	9p.o\
	util.o\
	lib/strecpy.o\
	lib/convD2M.o\
	lib/convM2D.o\
	lib/convM2S.o\
	lib/convS2M.o\
	lib/read9pmsg.o\
	lib/readn.o\
	lib/auth_proxy.o\
	lib/auth_rpc.o\
	lib/auth_getkey.o
HFILES=9pfs.h\
	auth.h\
	fcall.h\
	util.h\
	libc.h
CC=	cc
DEBUG=	-g
CFLAGS=	-O2 -pipe\
		${DEBUG} -Wall\
		-D_FILE_OFFSET_BITS=64\
		-DFUSE_USE_VERSION=26\
		-D_GNU_SOURCE
LDFLAGS=
LDADD=	-lfuse

all:	${TARG}

install:	${TARG} ${TARG}.1
	install -s -m 555 -g bin ${TARG} ${BIN}
	install -m 444 -g bin ${TARG}.1 ${MAN}

installman:	${TARG}.1
	install -m 444 -g bin ${TARG}.1 ${MAN}

uninstall:
	rm -f ${BIN}/${TARG}
	rm -f ${MAN}/${TARG}.1

uninstallman:
	rm -f ${MAN}/${TARG}.1

${TARG}:	${OBJS} ${HFILES}
	${CC} ${LDFLAGS} -o $@ ${OBJS} ${LDADD}

.c.o:
	${CC} -c -o $@ ${CFLAGS} $<

clean:
	rm -f ${TARG} ${OBJS} tests/test_breakpath ${TESTOBJS}

TESTCFLAGS = $(CFLAGS) -fcommon
TESTOBJS = tests/9pfs.o tests/9p.o tests/util.o \
        tests/lib/strecpy.o tests/lib/convD2M.o tests/lib/convM2D.o \
        tests/lib/convM2S.o tests/lib/convS2M.o tests/lib/read9pmsg.o \
        tests/lib/readn.o tests/lib/auth_proxy.o tests/lib/auth_rpc.o \
        tests/lib/auth_getkey.o

tests/%.o: %.c $(HFILES)
	@mkdir -p $(dir $@)
	$(CC) -c -o $@ $(TESTCFLAGS) $<

tests/9pfs.o: 9pfs.c $(HFILES)
	@mkdir -p $(dir $@)
	$(CC) -c -o $@ $(TESTCFLAGS) -Dmain=unused_main $<

tests/test_breakpath: tests/test_breakpath.c $(TESTOBJS)
	$(CC) -o $@ $(TESTOBJS) $< $(LDADD)

check: tests/test_breakpath
	./tests/test_breakpath
