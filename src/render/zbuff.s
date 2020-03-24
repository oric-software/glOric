#include "config.h"

#ifdef USE_MULTI40
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
#endif // USE_MULTI40


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



#ifdef USE_ASM_BUFFER2SCREEN

.text

_buffer2screen:
.(
	ldy #$00

buffer2screen_loop_01:

	lda _fbuffer, y 
	sta ADR_BASE_LORES_SCREEN,y
	lda _fbuffer+256, y 
	sta ADR_BASE_LORES_SCREEN+256,y
	lda _fbuffer+512, y 
	sta ADR_BASE_LORES_SCREEN+512,y
	lda _fbuffer+768, y 
	sta ADR_BASE_LORES_SCREEN+768,y
	iny
	bne buffer2screen_loop_01

	ldy #$10

buffer2screen_loop_02:

	lda _fbuffer+1024, y 
	sta ADR_BASE_LORES_SCREEN+1024,y
	dey
	bpl buffer2screen_loop_02

.)
    rts


#endif // USE_ASM_BUFFER2SCREEN


#ifdef USE_ASM_INITFRAMEBUFFER

// void initScreenBuffers()
_initScreenBuffers:
.(
  
    lda #$FF
    ldx #SCREEN_WIDTH-1

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
    sta _zbuffer+SCREEN_WIDTH*25 , x 
    sta _zbuffer+SCREEN_WIDTH*26 , x
    dex
    bne initScreenBuffersLoop_01

#ifndef USE_HORIZON
    lda #$20
#endif // USE_HORIZON

    ldx #SCREEN_WIDTH-1

initScreenBuffersLoop_02:
#ifdef USE_HORIZON
    lda #$20
#endif // USE_HORIZON
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
#ifdef USE_HORIZON
    lda #102 ;; light green
#endif // USE_HORIZON
    sta _fbuffer+SCREEN_WIDTH*14 , x
    sta _fbuffer+SCREEN_WIDTH*15 , x
    sta _fbuffer+SCREEN_WIDTH*16 , x
    sta _fbuffer+SCREEN_WIDTH*17 , x
    sta _fbuffer+SCREEN_WIDTH*18 , x
    sta _fbuffer+SCREEN_WIDTH*19 , x
    sta _fbuffer+SCREEN_WIDTH*20 , x
    sta _fbuffer+SCREEN_WIDTH*21 , x
#ifndef USE_COLOR
    sta _fbuffer+SCREEN_WIDTH*22 , x
    sta _fbuffer+SCREEN_WIDTH*23 , x
    sta _fbuffer+SCREEN_WIDTH*24 , x
    sta _fbuffer+SCREEN_WIDTH*25 , x
    sta _fbuffer+SCREEN_WIDTH*26 , x
#endif
    dex
#ifdef USE_COLOR
 	cpx #2
 	beq initScreenBuffersDone
#endif // USE_COLOR
    bpl initScreenBuffersLoop_02
initScreenBuffersDone:
.)
    rts


#endif // USE_ASM_INITFRAMEBUFFER


#ifdef USE_ASM_ZPLOT

_fastzplot:
.(
#ifdef SAFE_CONTEXT
	// save context
    pha:txa:pha:tya:pha
	lda tmp6: pha: lda tmp6+1 : pha ;; ptrFbuf
	lda tmp7: pha: lda tmp7+1 : pha ;; ptrZbuf
#endif

// #ifdef USE_COLOR
//    if ((Y <= 0) || (Y >= SCREEN_HEIGHT-NB_LESS_LINES_4_COLOR) || (X <= 2) || (X >= SCREEN_WIDTH))
//        return;
// #else
//    if ((Y <= 0) || (Y >= SCREEN_HEIGHT) || (X <= 0) || (X >= SCREEN_WIDTH))
//        return;
// #endif

	lda		_plotY
    beq		fastzplot_done
    bmi		fastzplot_done
#ifdef USE_COLOR
    cmp		#SCREEN_HEIGHT-NB_LESS_LINES_4_COLOR
#else
	cmp		#SCREEN_HEIGHT
#endif
    bcs		fastzplot_done
    tax

	lda		_plotX
#ifdef USE_COLOR
	sec
	sbc		#COLUMN_OF_COLOR_ATTRIBUTE
	bvc		*+4
	eor		#$80
	bmi		fastzplot_done

	lda		_plotX				; Reload X coordinate
    cmp		#SCREEN_WIDTH
    bcs		fastzplot_done

#else
    beq		fastzplot_done
    bmi		fastzplot_done
    cmp		#SCREEN_WIDTH
    bcs		fastzplot_done
#endif

    // ptrZbuf = zbuffer + Y*SCREEN_WIDTH+X;;
	lda		ZBufferAdressLow,x	; Get the LOW part of the zbuffer adress
	clc						; Clear the carry (because we will do an addition after)
	adc		_plotX				; Add X coordinate
	sta		tmp7 ; ptrZbuf
	lda		ZBufferAdressHigh,x	; Get the HIGH part of the zbuffer adress
	adc		#0					; Eventually add the carry to complete the 16 bits addition
	sta		tmp7+1	 ; ptrZbuf+ 1			

    // if (dist < *ptrZbuf) {
    lda 	_distpoint		; Access dist
    ldx		#0
    cmp		(tmp7,x)
    bcs		fastzplot_done

    //    *ptrZbuf = dist;
        ldx		#0
        sta		(tmp7, x)
    //    *ptrFbuf = char2disp;
        ldx		_plotY    ; reload Y coordinate
    	lda		FBufferAdressLow,x	; Get the LOW part of the fbuffer adress
        clc						; Clear the carry (because we will do an addition after)
        ;;ldy #0
        adc		_plotX				; Add X coordinate
        sta		tmp6 ; ptrFbuf
        lda		FBufferAdressHigh,x	; Get the HIGH part of the fbuffer adress
        adc		#0					; Eventually add the carry to complete the 16 bits addition
        sta		tmp6+1	 ; ptrFbuf+ 1			

        lda		_ch2disp		; Access char2disp
        ldx		#0
        sta		(tmp6,x)

    //}


fastzplot_done:
#ifdef SAFE_CONTEXT
	// restore context
	pla: sta tmp7+1: pla: sta tmp7
	pla: sta tmp6+1: pla: sta tmp6
	pla:tay:pla:tax:pla
#endif
.)
	rts

// void zplot(unsigned char X,
//           unsigned char Y,
//           unsigned char dist,
//           char          char2disp) {

_zplot:
.(
; sp+0 => X coordinate
; sp+2 => Y coordinate
; sp+4 => dist
; sp+6 => char2disp

	// save context
    pha:tya:pha

	ldy		#2
	lda		(sp),y				; Access Y coordinate
	sta		_plotY

	ldy		#0
	lda		(sp),y				; Access X coordinate
	sta		_plotX

    ldy		#4
    lda		(sp),y				; Access dist
	sta		_distpoint

	ldy		#6
	lda		(sp),y				; Access char2disp
	sta 	_ch2disp

	jsr 	_fastzplot

zplot_done:
	// restore context
	pla:tay:pla

.)
    rts

#endif // USE_ASM_ZPLOT


#ifdef USE_ASM_ZLINE

// void zline(signed char   dx,
//           signed char   py,
//           signed char   nbpoints,
//           unsigned char dist,
//           char          char2disp) {

_zline:
.(
; sp+0 => dx
; sp+2 => py
; sp+4 => nbpoints
; sp+6 => dist
; sp+8 => char2disp

	// save context
    pha
	lda tmp0: pha: lda tmp0+1 : pha ;; ptrFbuf
	lda tmp1: pha: lda tmp1+1 : pha ;; ptrZbuf
	lda reg0: pha ;; store py temporarily
    lda reg1: pha ;; nbpoints
    lda reg2: pha ;; dx
    lda reg3: pha ;; dist
    lda reg4: pha ;; char2disp


    // int            offset;   // offset os starting point
    // char*          ptrFbuf;  // pointer to the frame buffer
    // unsigned char* ptrZbuf;  // pointer to z-buffer
    // signed char    nbp;

	ldy #0
	lda (sp),y				; Access dx 
    sta reg2

	ldy #2
	lda (sp),y				; Access py 
    sta reg0
    tax

	ldy #4
	lda (sp),y				; Access nbpoints 
    beq zline_done
    sta reg1

	ldy #6
	lda (sp),y				; Access dist 
    sta reg3

	ldy #8
	lda (sp),y				; Access char2disp 
    sta reg4

    // nbp     = nbpoints;

    // ptrZbuf = zbuffer + py * SCREEN_WIDTH + dx;
 	lda ZBufferAdressLow,x	; Get the LOW part of the zbuffer adress
	clc						
	adc reg2				; Add dx coordinate
	sta tmp1                ; ptrZbuf
	lda ZBufferAdressHigh,x	; Get the HIGH part of the zbuffer adress
	adc #0					; 
	sta tmp1+1	 ; ptrZbuf+ 1			

    // ptrFbuf = fbuffer + py * SCREEN_WIDTH + dx;
    lda FBufferAdressLow,x	; Get the LOW part of the fbuffer adress
    clc						; 
    adc reg2				; Add dx coordinate
    sta tmp0                ; ptrFbuf
    lda FBufferAdressHigh,x	; Get the HIGH part of the fbuffer adress
    adc #0					; 
    sta tmp0+1	            ; ptrFbuf+ 1			

   // ptrFbuf = fbuffer + offset;

    // while (nbp > 0) {
    ldy reg1
_zline2_loop:
    

    //     if (dist < ptrZbuf[nbp]) {
    lda (tmp1), y
    cmp reg3
    bcc zline_distOver
    //         // printf ("p [%d %d] <- %d. was %d \n", dx+nbpoints, py, dist, ptrZbuf
    //         // [nbpoints]);
    //         ptrFbuf[nbp] = char2disp;
    lda reg4
    sta (tmp0), y
    //         ptrZbuf[nbp] = dist;
    lda reg3
    sta (tmp1), y
   //     }
zline_distOver:
    //     nbp--;
    dey
    bne _zline2_loop
    // }


zline_done:
	// restore context
	pla: sta reg4
	pla: sta reg3
	pla: sta reg2
	pla: sta reg1
    pla: sta reg0
	pla: sta tmp1+1: pla: sta tmp1
	pla: sta tmp0+1: pla: sta tmp0
	pla

.)
    rts

#endif // USE_ASM_ZLINE


// unsigned char zbuffer[SCREEN_WIDTH * SCREEN_HEIGHT];  // z-depth buffer
// char          fbuffer[SCREEN_WIDTH * SCREEN_HEIGHT];  // frame buffer

_fbuffer
	.dsb 1080
_zbuffer
	.dsb 1080
