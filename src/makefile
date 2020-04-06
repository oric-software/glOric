
.SUFFIXES: 
.SUFFIXES: .asm .c

PATH_TO_ORICUTRON=C:\Users\Public\Orix

LIBNAME=glOric
PROGNAME=glDemo

PLATFORM=telestrat
XA="C:\Users\Public\osdk_1_15\Bin/xa.exe"
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

%.asm: %.c
	$(CC) $(CFLAGS) $^ -o $@

.PHONY: mrproper all test 


$(LIBNAME).lib: $(OBJS)
	$(AR) $(ARFLAGS) $@ $^

$(PROGNAME).tap: $(LIBNAME).lib start.o
	$(LD) -m $(@:.tap=.map) -Ln $(@:.tap=.vice) $(LDFLAGS) start.o $(LIBNAME).lib -o $(PROGNAME).tap

GL: glOric_s.s start.c
	$(XA) -v -R -cc -e error.txt -l xa_labels.txt -DTARGET_ORIX -DSAVE_ZERO_PAGE glOric_s.s -o glOric_s.o
	co65 glOric_s.o -o glOric_s.asm
	$(AS) $(ASFLAGS) glOric_s.asm -l glOric_s.lst -o glOric_s.o
	$(LD) -m GL.map -Ln GL.vice $(LDFLAGS) start.o glOric_s.o -o GL.tap
	cp GL.tap $(PATH_TO_ORICUTRON)\usbdrive\bin\

#	cl65 -g -o GL -DTARGET_ORIX -DSAVE_ZERO_PAGE -ttelestrat start.c glOric_s.asm
#	cp GL $(PATH_TO_ORICUTRON)\usbdrive\bin\

all: $(LIBNAME).lib $(PROGNAME).tap

test: $(PROGNAME).tap
	cp $(PROGNAME).tap $(PATH_TO_ORICUTRON)\usbdrive\bin\$(PROGNAME)

clean:
	rm -f *.o $(SRC_C:.c=.asm) *.lst *.map *.vice

mrproper: clean
	rm $(LIBNAME).lib $(PROGNAME).tap
