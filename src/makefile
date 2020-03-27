
.SUFFIXES: 
.SUFFIXES: .asm .c

PATH_TO_ORICUTRON=C:\Users\Public\Orix

LIBNAME=glOric
PROGNAME=glDemo

PLATFORM=telestrat

AS=ca65
ASFLAGS=-t$(PLATFORM) -g --include-dir .
CC=cc65
CFLAGS=-D TARGET_ORIX -g 
AR=ar65
ARFLAGS=r
LD=cl65
LDFLAGS=-v -vm -g -t$(PLATFORM) 

SRC_ASM= camera.asm temp.asm fill8.asm zbuff.asm hzfill.asm projection.asm projectPoint.asm scene.asm
SRC_C= glOric_c.c
OBJS= $(SRC_ASM:.asm=.o) $(SRC_C:.c=.o)

%.o: %.asm
	$(AS) $(ASFLAGS) $^ -l $(@:.o=.lst) -o $@

%.o: %.c
	$(CC) $(CFLAGS) $^ -o $@

$(LIBNAME).lib: $(OBJS)
	$(AR) $(ARFLAGS) $@ $^

$(PROGNAME).tap: 
	$(LD) $(LDFLAGS) start.o $(LIBNAME).lib -o $(PROGNAME).tap

all: $(LIBNAME).lib $(PROGNAME).tap
	cp $(PROGNAME).tap $(PATH_TO_ORICUTRON)\usbdrive\bin\$(PROGNAME)


clean:
	rm -f *.o $(SRC_C:.c=.asm) *.lst *.map *.vice

mrproper: clean
	rm $(LIBNAME).lib $(PROGNAME).tap
