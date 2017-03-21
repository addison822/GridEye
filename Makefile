
DESTDIR=/usr
PREFIX=/local

LDCONFIG=ldconfig

STATIC=libgrideye.a
DYNAMIC=libgrideye.so

CC	= g++
INCLUDE	= -I.
CFLAGS	= -fPIC -O2 $(INCLUDE)
#CFLAGS	= -fPIC -O2 -Wformat=2 -Wall -Wextra -Winline $(INCLUDE)

###############################################################################

SRC	=	grideye.cpp

HEADERS =	$(SRC:.cpp=.h)

OBJ	=	$(SRC:.cpp=.o)

all:		$(DYNAMIC)

static:		$(STATIC)

$(STATIC):	$(OBJ)
	@ echo "[Link (Static)]"
	@ ar rcs $(STATIC) $(OBJ)
	@ ranlib $(STATIC)

$(DYNAMIC):	$(OBJ)
	@ echo "[Link (Dynamic)]"
	@ $(CC) -shared -Wl,-soname,libgrideye.so.1 -o libgrideye.so.1.0.0 $(OBJ)

$(OBJ): %.o: %.cpp
	@ echo [Compile] $<
	@ $(CC) -c $(CFLAGS) $< -o $@

.PHONY:	clean
clean:
	@ echo "[Clean]"
	@ rm -f $(OBJ) libgrideye.*

.PHONY:	install
install:	$(DYNAMIC)
	@ echo "[Install Headers]"
	@ install -m 0755 -d					$(DESTDIR)$(PREFIX)/include
	@ install -m 0644 $(HEADERS)			$(DESTDIR)$(PREFIX)/include
	@ echo "[Install Dynamic Lib]"
	@ install -m 0755 -d					$(DESTDIR)$(PREFIX)/lib
	@ install -m 0755 $(DYNAMIC).1.0.0		$(DESTDIR)$(PREFIX)/lib/$(DYNAMIC).1.0.0
	@ ln -sf $(DESTDIR)$(PREFIX)/lib/$(DYNAMIC).1.0.0	$(DESTDIR)/lib/$(DYNAMIC)
	@ $(LDCONFIG)

.PHONY:	install-static
install-static:	$(STATIC)
	@ echo "[Install Headers]"
	@ install -m 0755 -d				$(DESTDIR)$(PREFIX)/include
	@ install -m 0644 $(HEADERS)		$(DESTDIR)$(PREFIX)/include
	@ echo "[Install Static Lib]"
	@ install -m 0755 -d				$(DESTDIR)$(PREFIX)/lib
	@ install -m 0755 $(STATIC)			$(DESTDIR)$(PREFIX)/lib

.PHONY:	uninstall
uninstall:
	@ echo "[UnInstall]"
	@ cd $(DESTDIR)$(PREFIX)/include/ && rm -f $(HEADERS)
	@ cd $(DESTDIR)$(PREFIX)/lib/     && rm -f libgrideye.*
	@ $(LDCONFIG)