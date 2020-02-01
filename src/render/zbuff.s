#include "config.h"

_multi40
	.word 0
	.word 40
	.word 80
	.word 120
	.word 160
	.word 200
	.word 240
	.word 280
	.word 320
	.word 360
	.word 400
	.word 440
	.word 480
	.word 520
	.word 560
	.word 600
	.word 640
	.word 680
	.word 720
	.word 760
	.word 800
	.word 840
	.word 880
	.word 920
	.word 960
	.word 1000
	.word 1040



; This table contains lower 8 bits of the adress
ZBufferAdressLow
	.byt <(_zbuffer+40*0)
	.byt <(_zbuffer+40*1)
	.byt <(_zbuffer+40*2)
	.byt <(_zbuffer+40*3)
	.byt <(_zbuffer+40*4)
	.byt <(_zbuffer+40*5)
	.byt <(_zbuffer+40*6)
	.byt <(_zbuffer+40*7)
	.byt <(_zbuffer+40*8)
	.byt <(_zbuffer+40*9)
	.byt <(_zbuffer+40*10)
	.byt <(_zbuffer+40*11)
	.byt <(_zbuffer+40*12)
	.byt <(_zbuffer+40*13)
	.byt <(_zbuffer+40*14)
	.byt <(_zbuffer+40*15)
	.byt <(_zbuffer+40*16)
	.byt <(_zbuffer+40*17)
	.byt <(_zbuffer+40*18)
	.byt <(_zbuffer+40*19)
	.byt <(_zbuffer+40*20)
	.byt <(_zbuffer+40*21)
	.byt <(_zbuffer+40*22)
	.byt <(_zbuffer+40*23)
	.byt <(_zbuffer+40*24)
	.byt <(_zbuffer+40*25)
	.byt <(_zbuffer+40*26)
	.byt <(_zbuffer+40*27)

; This table contains hight 8 bits of the adress
ZBufferAdressHigh
	.byt >(_zbuffer+40*0)
	.byt >(_zbuffer+40*1)
	.byt >(_zbuffer+40*2)
	.byt >(_zbuffer+40*3)
	.byt >(_zbuffer+40*4)
	.byt >(_zbuffer+40*5)
	.byt >(_zbuffer+40*6)
	.byt >(_zbuffer+40*7)
	.byt >(_zbuffer+40*8)
	.byt >(_zbuffer+40*9)
	.byt >(_zbuffer+40*10)
	.byt >(_zbuffer+40*11)
	.byt >(_zbuffer+40*12)
	.byt >(_zbuffer+40*13)
	.byt >(_zbuffer+40*14)
	.byt >(_zbuffer+40*15)
	.byt >(_zbuffer+40*16)
	.byt >(_zbuffer+40*17)
	.byt >(_zbuffer+40*18)
	.byt >(_zbuffer+40*19)
	.byt >(_zbuffer+40*20)
	.byt >(_zbuffer+40*21)
	.byt >(_zbuffer+40*22)
	.byt >(_zbuffer+40*23)
	.byt >(_zbuffer+40*24)
	.byt >(_zbuffer+40*25)
	.byt >(_zbuffer+40*26)
	.byt >(_zbuffer+40*27)


; This table contains lower 8 bits of the adress
FBufferAdressLow
	.byt <(_fbuffer+40*0)
	.byt <(_fbuffer+40*1)
	.byt <(_fbuffer+40*2)
	.byt <(_fbuffer+40*3)
	.byt <(_fbuffer+40*4)
	.byt <(_fbuffer+40*5)
	.byt <(_fbuffer+40*6)
	.byt <(_fbuffer+40*7)
	.byt <(_fbuffer+40*8)
	.byt <(_fbuffer+40*9)
	.byt <(_fbuffer+40*10)
	.byt <(_fbuffer+40*11)
	.byt <(_fbuffer+40*12)
	.byt <(_fbuffer+40*13)
	.byt <(_fbuffer+40*14)
	.byt <(_fbuffer+40*15)
	.byt <(_fbuffer+40*16)
	.byt <(_fbuffer+40*17)
	.byt <(_fbuffer+40*18)
	.byt <(_fbuffer+40*19)
	.byt <(_fbuffer+40*20)
	.byt <(_fbuffer+40*21)
	.byt <(_fbuffer+40*22)
	.byt <(_fbuffer+40*23)
	.byt <(_fbuffer+40*24)
	.byt <(_fbuffer+40*25)
	.byt <(_fbuffer+40*26)
	.byt <(_fbuffer+40*27)

; This table contains hight 8 bits of the adress
FBufferAdressHigh
	.byt >(_fbuffer+40*0)
	.byt >(_fbuffer+40*1)
	.byt >(_fbuffer+40*2)
	.byt >(_fbuffer+40*3)
	.byt >(_fbuffer+40*4)
	.byt >(_fbuffer+40*5)
	.byt >(_fbuffer+40*6)
	.byt >(_fbuffer+40*7)
	.byt >(_fbuffer+40*8)
	.byt >(_fbuffer+40*9)
	.byt >(_fbuffer+40*10)
	.byt >(_fbuffer+40*11)
	.byt >(_fbuffer+40*12)
	.byt >(_fbuffer+40*13)
	.byt >(_fbuffer+40*14)
	.byt >(_fbuffer+40*15)
	.byt >(_fbuffer+40*16)
	.byt >(_fbuffer+40*17)
	.byt >(_fbuffer+40*18)
	.byt >(_fbuffer+40*19)
	.byt >(_fbuffer+40*20)
	.byt >(_fbuffer+40*21)
	.byt >(_fbuffer+40*22)
	.byt >(_fbuffer+40*23)
	.byt >(_fbuffer+40*24)
	.byt >(_fbuffer+40*25)
	.byt >(_fbuffer+40*26)
	.byt >(_fbuffer+40*27)

// void initScreenBuffers()
_initScreenBuffers:
.(
  
    lda #$FF
    ldx #40

initScreenBuffersLoop_01:
    sta _zbuffer+SCREEN_WIDTH*0 , x
    sta _zbuffer+SCREEN_WIDTH*1 , x
    sta _zbuffer+SCREEN_WIDTH*2 , x
    sta _zbuffer+SCREEN_WIDTH*3 , x
    sta _zbuffer+SCREEN_WIDTH*4 , x
    sta _zbuffer+SCREEN_WIDTH*5 , x
    sta _zbuffer+SCREEN_WIDTH*6 , x
    sta _zbuffer+SCREEN_WIDTH*7 , x
    sta _zbuffer+SCREEN_WIDTH*8 , x
    sta _zbuffer+SCREEN_WIDTH*9 , x
    sta _zbuffer+SCREEN_WIDTH*10 , x
    sta _zbuffer+SCREEN_WIDTH*11 , x
    sta _zbuffer+SCREEN_WIDTH*12 , x
    sta _zbuffer+SCREEN_WIDTH*13 , x
    sta _zbuffer+SCREEN_WIDTH*14 , x
    sta _zbuffer+SCREEN_WIDTH*15 , x
    sta _zbuffer+SCREEN_WIDTH*16 , x
    sta _zbuffer+SCREEN_WIDTH*17 , x
    sta _zbuffer+SCREEN_WIDTH*18 , x
    sta _zbuffer+SCREEN_WIDTH*19 , x
    sta _zbuffer+SCREEN_WIDTH*20 , x
    sta _zbuffer+SCREEN_WIDTH*21 , x
    sta _zbuffer+SCREEN_WIDTH*22 , x
    sta _zbuffer+SCREEN_WIDTH*23 , x
    sta _zbuffer+SCREEN_WIDTH*24 , x
    ;sta _zbuffer+SCREEN_WIDTH*25 , x
    ;sta _zbuffer+SCREEN_WIDTH*26 , x
    dex
    bne initScreenBuffersLoop_01

    lda #$20
    ldx #40

initScreenBuffersLoop_02:
    sta _fbuffer+SCREEN_WIDTH*0 , x
    sta _fbuffer+SCREEN_WIDTH*1 , x
    sta _fbuffer+SCREEN_WIDTH*2 , x
    sta _fbuffer+SCREEN_WIDTH*3 , x
    sta _fbuffer+SCREEN_WIDTH*4 , x
    sta _fbuffer+SCREEN_WIDTH*5 , x
    sta _fbuffer+SCREEN_WIDTH*6 , x
    sta _fbuffer+SCREEN_WIDTH*7 , x
    sta _fbuffer+SCREEN_WIDTH*8 , x
    sta _fbuffer+SCREEN_WIDTH*9 , x
    sta _fbuffer+SCREEN_WIDTH*10 , x
    sta _fbuffer+SCREEN_WIDTH*11 , x
    sta _fbuffer+SCREEN_WIDTH*12 , x
    sta _fbuffer+SCREEN_WIDTH*13 , x
    sta _fbuffer+SCREEN_WIDTH*14 , x
    sta _fbuffer+SCREEN_WIDTH*15 , x
    sta _fbuffer+SCREEN_WIDTH*16 , x
    sta _fbuffer+SCREEN_WIDTH*17 , x
    sta _fbuffer+SCREEN_WIDTH*18 , x
    sta _fbuffer+SCREEN_WIDTH*19 , x
    sta _fbuffer+SCREEN_WIDTH*20 , x
    sta _fbuffer+SCREEN_WIDTH*21 , x
    sta _fbuffer+SCREEN_WIDTH*22 , x
    sta _fbuffer+SCREEN_WIDTH*23 , x
    sta _fbuffer+SCREEN_WIDTH*24 , x
    ;sta _fbuffer+SCREEN_WIDTH*25 , x
    ;sta _fbuffer+SCREEN_WIDTH*26 , x
    dex
    bne initScreenBuffersLoop_02

.)
    rts



// void buffer2screen(char destAdr[])
; http://www.6502.org/source/general/memory_move.html
; Bruce Clark
; Move memory down
; FROM = source start address
;   TO = destination start address
; SIZE = number of bytes to move

.zero
FROM .dsb 2
TO .dsb 2

.text

_buffer2screen:
.(

; lda #<(48040) : sta TO : lda #>(48040) : sta TO+1 :
	ldy #0: lda (sp),y: sta TO: iny: lda (sp),y: sta TO+1
    lda #<(_fbuffer) : sta FROM : lda #>(_fbuffer) : sta FROM+1 

MOVEDOWN LDY #0
         LDX #<(SCREEN_WIDTH*SCREEN_HEIGHT); SIZEH
         BEQ MD2
MD1      LDA (FROM),Y ; move a page at a time
         STA (TO),Y
         INY
         BNE MD1
         INC FROM+1
         INC TO+1
         DEX
         BNE MD1
MD2      LDX #>(SCREEN_WIDTH*SCREEN_HEIGHT); SIZEL
         BEQ MD4
MD3      LDA (FROM),Y ; move the remaining bytes
         STA (TO),Y
         INY
         DEX
         BNE MD3
MD4      
.)
    RTS


// void zplot(unsigned char X,
//           unsigned char Y,
//           unsigned char dist,
//           char          char2disp) {

_zplot:
.(
; 	ldx #10 : lda #3 : jsr enter :
; 	ldy #0 : lda (ap),y : sta tmp0 : iny : lda (ap),y : sta tmp0+1 :
; 	lda tmp0 : sta reg0 :
; 	ldy #2 : lda (ap),y : sta tmp0 : iny : lda (ap),y : sta tmp0+1 :
; 	lda tmp0 : sta reg1 :
; 	ldy #4 : lda (ap),y : sta tmp0 : iny : lda (ap),y : sta tmp0+1 :
; 	ldy #4 : lda tmp0 : sta (ap),y :
; 	ldy #6 : lda (ap),y : sta tmp0 : iny : lda (ap),y : sta tmp0+1 :
; 	ldy #6 : lda tmp0 : sta (ap),y :
; 	lda reg1 : sta tmp0 :
; 	lda tmp0 : sta tmp0 : lda #0 : sta tmp0+1 :
; 	lda #<(0) : cmp tmp0 : lda #>(0) : sbc tmp0+1 : bvc *+4 : eor #$80 : bmi *+5 : jmp Lzbuffer133 : : :
; 	lda tmp0 : cmp #<(26) : lda tmp0+1 : sbc #>(26) : bvc *+4 : eor #$80 : bmi *+5 : jmp Lzbuffer133 : :
; 	lda reg0 : sta tmp0 :
; 	lda tmp0 : sta tmp0 : lda #0 : sta tmp0+1 :
; 	lda #<(0) : cmp tmp0 : lda #>(0) : sbc tmp0+1 : bvc *+4 : eor #$80 : bmi *+5 : jmp Lzbuffer133 : : :
; 	lda tmp0 : cmp #<(40) : lda tmp0+1 : sbc #>(40) : .( : bvc *+4 : eor #$80 : bpl skip : jmp Lzbuffer129 :skip : .) : :
; Lzbuffer133
; 	jmp leave :
; Lzbuffer129
; 	lda reg1 : sta tmp0 :
; 	lda tmp0 : sta tmp0 : lda #0 : sta tmp0+1 :
; 	lda tmp0 : asl : sta tmp0 : lda tmp0+1 : rol : sta tmp0+1 :
; 	clc : lda #<(_multi40) : adc tmp0 : sta tmp0 : lda #>(_multi40) : adc tmp0+1 : sta tmp0+1 :
; 	ldy #0 : lda (tmp0),y : tax : iny : lda (tmp0),y : stx tmp0 : sta tmp0+1 :
; 	lda reg0 : sta tmp1 :
; 	lda tmp1 : sta tmp1 : lda #0 : sta tmp1+1 :
; 	clc : lda tmp0 : adc tmp1 : sta tmp0 : lda tmp0+1 : adc tmp1+1 : sta tmp0+1 :
; 	lda tmp0 : sta reg2 : lda tmp0+1 : sta reg2+1 :
; 	lda reg2 : sta tmp0 : lda reg2+1 : sta tmp0+1 :
; 	clc : lda #<(_zbuffer) : adc tmp0 : sta tmp1 : lda #>(_zbuffer) : adc tmp0+1 : sta tmp1+1 :
; 	ldy #6 : lda tmp1 : sta (fp),y : iny : lda tmp1+1 : sta (fp),y :
; 	clc : lda #<(_fbuffer) : adc tmp0 : sta tmp0 : lda #>(_fbuffer) : adc tmp0+1 : sta tmp0+1 :
; 	ldy #8 : lda tmp0 : sta (fp),y : iny : lda tmp0+1 : sta (fp),y :
; 	ldy #4 : lda (ap),y : sta tmp0 :
; 	lda tmp0 : sta tmp0 : lda #0 : sta tmp0+1 :
; 	ldy #6 : lda (fp),y : sta tmp1 : iny : lda (fp),y : sta tmp1+1 :
; 	ldy #0 : lda (tmp1),y : sta tmp1 :
; 	lda tmp1 : sta tmp1 : lda #0 : sta tmp1+1 :
; 	lda tmp0 : cmp tmp1 : lda tmp0+1 : sbc tmp1+1 : bvc *+4 : eor #$80 : bmi *+5 : jmp Lzbuffer134 : :
; 	ldy #8 : lda (fp),y : sta tmp0 : iny : lda (fp),y : sta tmp0+1 :
; 	ldy #6 : lda (ap),y : sta tmp1 :
; 	ldy #0 : lda tmp1 : sta (tmp0),y :
; 	ldy #6 : lda (fp),y : sta tmp0 : iny : lda (fp),y : sta tmp0+1 :
; 	ldy #4 : lda (ap),y : sta tmp1 :
; 	ldy #0 : lda tmp1 : sta (tmp0),y :
; Lzbuffer134
; 	jmp leave :

; sp+0 => X coordinate
; sp+2 => Y coordinate
; sp+4 => dist
; sp+4 => char2disp

	// save context
    pha
	lda tmp0: pha: lda tmp0+1 : pha ;; ptrFbuf
	lda tmp1: pha: lda tmp1+1 : pha ;; ptrZbuf
	lda reg0: pha ;; store Y temporarily
    lda reg1 : pha ;; 



//    if ((Y <= 0) || (Y >= SCREEN_HEIGHT) || (X <= 0) || (X >= SCREEN_WIDTH))        return;
	ldy #2
	lda (sp),y				; Access Y coordinate
    beq zplot_done
    bmi zplot_done
    cmp #SCREEN_HEIGHT
    bcs zplot_done
    sta reg0
    tax

	ldy #0
	lda (sp),y				; Access X coordinate
    beq zplot_done
    bmi zplot_done
    cmp #SCREEN_WIDTH
    bcs zplot_done
    sta reg1

    // ptrZbuf = zbuffer + Y*SCREEN_WIDTH+X;;
	lda ZBufferAdressLow,x	; Get the LOW part of the zbuffer adress
	clc						; Clear the carry (because we will do an addition after)
	;;ldy #0
	adc reg1				; Add X coordinate
	sta tmp1 ; ptrZbuf
	lda ZBufferAdressHigh,x	; Get the HIGH part of the zbuffer adress
	adc #0					; Eventually add the carry to complete the 16 bits addition
	sta tmp1+1	 ; ptrZbuf+ 1			

    // if (dist < *ptrZbuf) {
    ldy #4
    lda (sp),y				; Access dist
    ldx #0
    cmp (tmp1,x)
    bcs zplot_done
 
    //    *ptrZbuf = dist;
        ldx #0
        sta (tmp1, x)
    //    *ptrFbuf = char2disp;
        ldx reg0    ; reload Y coordinate
    	lda FBufferAdressLow,x	; Get the LOW part of the zbuffer adress
        clc						; Clear the carry (because we will do an addition after)
        ;;ldy #0
        adc reg1				; Add X coordinate
        sta tmp0 ; ptrFbuf
        lda FBufferAdressHigh,x	; Get the HIGH part of the zbuffer adress
        adc #0					; Eventually add the carry to complete the 16 bits addition
        sta tmp0+1	 ; ptrFbuf+ 1			

        ldy #6
        lda (sp),y				; Access char2disp
        ldx #0
        sta (tmp0,x)

    //}

zplot_done:
	// restore context
	pla: sta reg1
    pla: sta reg0
	pla: sta tmp1+1: pla: sta tmp1
	pla: sta tmp0+1: pla: sta tmp0
	pla

.)
    rts



_zline:
.(
	ldx #6 : lda #6 : jsr enter :
	ldy #0 : lda (ap),y : sta tmp0 : iny : lda (ap),y : sta tmp0+1 :
	ldy #0 : lda tmp0 : sta (ap),y :
	ldy #2 : lda (ap),y : sta tmp0 : iny : lda (ap),y : sta tmp0+1 :
	ldy #2 : lda tmp0 : sta (ap),y :
	ldy #4 : lda (ap),y : sta tmp0 : iny : lda (ap),y : sta tmp0+1 :
	ldy #4 : lda tmp0 : sta (ap),y :
	ldy #6 : lda (ap),y : sta tmp0 : iny : lda (ap),y : sta tmp0+1 :
	lda tmp0 : sta reg0 :
	ldy #8 : lda (ap),y : sta tmp0 : iny : lda (ap),y : sta tmp0+1 :
	lda tmp0 : sta reg1 :
	ldy #4 : lda (ap),y : sta tmp0 :
	lda tmp0 : sta reg2 :
	ldy #2 : lda (ap),y : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : asl : sta tmp0 : lda tmp0+1 : rol : sta tmp0+1 :
	clc : lda #<(_multi40) : adc tmp0 : sta tmp0 : lda #>(_multi40) : adc tmp0+1 : sta tmp0+1 :
	ldy #0 : lda (tmp0),y : tax : iny : lda (tmp0),y : stx tmp0 : sta tmp0+1 :
	ldy #0 : lda (ap),y : sta tmp1 :
	lda #0 : ldx tmp1 : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	clc : lda tmp0 : adc tmp1 : sta tmp0 : lda tmp0+1 : adc tmp1+1 : sta tmp0+1 :
	lda tmp0 : sta reg5 : lda tmp0+1 : sta reg5+1 :
	lda reg5 : sta tmp0 : lda reg5+1 : sta tmp0+1 :
	clc : lda #<(_zbuffer) : adc tmp0 : sta tmp1 : lda #>(_zbuffer) : adc tmp0+1 : sta tmp1+1 :
	lda tmp1 : sta reg3 : lda tmp1+1 : sta reg3+1 :
	clc : lda #<(_fbuffer) : adc tmp0 : sta tmp0 : lda #>(_fbuffer) : adc tmp0+1 : sta tmp0+1 :
	lda tmp0 : sta reg4 : lda tmp0+1 : sta reg4+1 :
	jmp Lzbuffer137 :
Lzbuffer136
	lda reg0 : sta tmp0 :
	lda tmp0 : sta tmp0 : lda #0 : sta tmp0+1 :
	lda reg2 : sta tmp1 :
	lda #0 : ldx tmp1 : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda reg3 : sta tmp2 : lda reg3+1 : sta tmp2+1 :
	clc : lda tmp1 : adc tmp2 : sta tmp1 : lda tmp1+1 : adc tmp2+1 : sta tmp1+1 :
	ldy #0 : lda (tmp1),y : sta tmp1 :
	lda tmp1 : sta tmp1 : lda #0 : sta tmp1+1 :
	lda tmp0 : cmp tmp1 : lda tmp0+1 : sbc tmp1+1 : bvc *+4 : eor #$80 : bmi *+5 : jmp Lzbuffer139 : :
	lda reg2 : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda reg4 : sta tmp1 : lda reg4+1 : sta tmp1+1 :
	clc : lda tmp0 : adc tmp1 : sta tmp0 : lda tmp0+1 : adc tmp1+1 : sta tmp0+1 :
	lda reg1 : sta tmp1 :
	ldy #0 : lda tmp1 : sta (tmp0),y :
	lda reg2 : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda reg3 : sta tmp1 : lda reg3+1 : sta tmp1+1 :
	clc : lda tmp0 : adc tmp1 : sta tmp0 : lda tmp0+1 : adc tmp1+1 : sta tmp0+1 :
	lda reg0 : sta tmp1 :
	ldy #0 : lda tmp1 : sta (tmp0),y :
Lzbuffer139
	lda reg2 : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : .( : bne skip : dec tmp0+1 :skip : .)  : dec tmp0 :
	lda tmp0 : sta reg2 :
Lzbuffer137
	lda reg2 : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : cmp #<(0) : lda tmp0+1 : sbc #>(0) : bvc *+4 : eor #$80 : bmi *+5 : jmp Lzbuffer136 : :
	jmp leave :
.)



_fbuffer
	.dsb 1040
_zbuffer
	.dsb 1040
