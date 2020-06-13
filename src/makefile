
.SUFFIXES: 
.SUFFIXES: .asm .c

PATH_TO_ORICUTRON="C:\Users\Public\Orix"

LIBNAME=glOric
PROGNAME=d

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

#SRC_ASM= camera.asm temp.asm fill8.asm zbuff.asm hzfill.asm projection.asm glProjectPoint.asm scene.asm
#SRC_C= glOric_c.c
#OBJS= $(SRC_ASM:.asm=.o) $(SRC_C:.c=.o)

%.o: %.asm
	$(AS) $(ASFLAGS) $^ -l $(@:.o=.lst) -o $@

%.asm: %.c
	$(CC) $(CFLAGS) $^ -o $@

#%.o: %.c
#	$(CC) $(CFLAGS) $^ -o $@

%.asm: %.s
	$(XA) -v -R -cc -e error.txt -l xa_labels.txt -DTARGET_ORIX -DSAVE_ZERO_PAGE $^ -o $(@:.asm=.o)
	co65 $(@:.asm=.o) -o $@
	rm -f $(@:.asm=.o)
	
	#$(XA) -v -R -cc -e error.txt -l xa_labels.txt -DTARGET_ORIX -DSAVE_ZERO_PAGE glOric_s.s -o glOric_s.o
	#co65 glOric_s.o -o glOric_s.asm
#%.o: %.asm
#	$(AS) $(ASFLAGS) $^ -l $(@:.o=.lst) -o $@

#GL: glOric_s.o start.o
#	$(LD) -m GL.map -Ln GL.vice $(LDFLAGS) start.o glOric_asm.o -o GL.tap
#	sed -re 's/al 00(.{4}) \.(.+)$$/\1 \2/' GL.vice | sort > $(PATH_TO_ORICUTRON)/symbols
#	cp GL.tap $(PATH_TO_ORICUTRON)/usbdrive/bin/d
#	cd $(PATH_TO_ORICUTRON) && ./oricutron.exe -s symbols &
#	cd -

#	cl65 -g -o GL -DTARGET_ORIX -DSAVE_ZERO_PAGE -ttelestrat start.c glOric_s.asm
#	cp GL $(PATH_TO_ORICUTRON)\usbdrive\bin\

$(PROGNAME).tap: glOric_s.o start.o
	$(LD) -m $(@:.tap=.map) -Ln $(@:.tap=.vice) $(LDFLAGS) $^  -o $(PROGNAME).tap
	sed -re 's/al 00(.{4}) \.(.+)$$/\1 \2/' $(@:.tap=.vice) | sort > $(PATH_TO_ORICUTRON)/symbols
	cp $@ $(PATH_TO_ORICUTRON)/usbdrive/bin/$(PROGNAME)


all: $(PROGNAME).tap

test: $(PROGNAME).tap
	cp $(PROGNAME).tap $(PATH_TO_ORICUTRON)\usbdrive\bin\$(PROGNAME)
	cd $(PATH_TO_ORICUTRON) && ./oricutron.exe -s symbols &
	cd -

# $(SRC_C:.c=.asm)

clean:
	rm -f *.o glOric_s.asm *.lst *.map *.vice error.txt xa_labels.txt $(PROGNAME).tap

