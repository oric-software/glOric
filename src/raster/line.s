#include "config.h"

.zero
_PosPrint .dsb 2

.text

_PrintX .dsb 1
_PrintY .dsb 1

_computePosPrint:
.(
    lda #$BB
    sta _PosPrint+1
    clc
    lda #$80
    adc _PrintX
    ldx _PrintY
    beq prdone
nxtline:
    adc #40
    bcc noincline
    inc _PosPrint+1
    clc
noincline:
    dex
    bne nxtline
prdone:
    sta _PosPrint
.)
    rts


err .dsb 1
e2 .dsb 1


dX .dsb 1
dY .dsb 1
stepX .dsb 1
stepY .dsb 1

plotOrNot:
.(
    lda _Point1X
	bmi plotdone
	beq plotdone
	cmp #SCREEN_WIDTH
	bpl plotdone
    sta _PrintX
    lda _Point1Y
	bmi plotdone
	beq plotdone
	cmp #SCREEN_HEIGHT
	bpl plotdone
    sta _PrintY
    jsr _computePosPrint
    lda _char2Display ;#42
    ldy #00
    sta (_PosPrint),y
plotdone:
.)
    rts

_drawLine:
.(
	// save context
    pha:txa:pha:tya:pha


    ;lda _Point1X
    ;sta _PrintX
    ;lda _Point1Y
    ;sta _PrintY
    ;jsr _printChar
    ;lda #65
    ;ldy #00
    ;sta (_PosPrint),y


//  dx =  abs(x1-x0);
//  sx = x0<x1 ? 1 : -1;
; a = x0-x1
    sec
    lda _Point1X
    sbc _Point2X
; if a >= 0 :
    bmi x1overx0
;   dx = a
    sta dX
;   sx = -1
    lda #$FF
    sta stepX
    jmp computeDy
; else
x1overx0:
;   dx = -a
    eor #$FF
    sec
    adc #$00
    sta dX
;   sx =1
    lda #$01
    sta stepX
; endif
computeDy:
//  dy = -abs(y1-y0);
//  sy = y0<y1 ? 1 : -1;
; a = y0-y1
    lda _Point1Y
    sec
    sbc _Point2Y
; if a >= 0 :
    bmi y1overy0
;   dy = -a
    eor #$FF
    sec
    adc #$00
    sta dY
;   sy = -1
    lda #$FF
    sta stepY
    jmp computeErr
; else
y1overy0:
;   dy = a
    sta dY
;   sy = 1
    lda #$01
    sta stepY
; endif
computeErr:
//  err = dx+dy;  /* error value e_xy */
; a = dx
    lda dX
; a = a + dy
    clc
    adc dY
; err = a
    sta err
//  if ((A1err >= 64) ||(A1err < -64)) return;
    sec
    sbc #$40
    .(:bvc skip : eor #$80: skip:.)
    bpl endloop
    lda err
    sec
    sbc #$C0
    .(:bvc skip : eor #$80: skip:.)
    bmi endloop

//  while (true)   /* loop */
drawloop:
//      PLOT (x0, y0)
        jsr plotOrNot
//      if (x0==x1 && y0==y1) break;
;       a = x0
        lda _Point1X
;       if a != x1 goto continue
        cmp _Point2X
        bne continue
;       a = y0
        lda _Point1Y
;       if a != y1 goto continue
        cmp _Point2Y
        bne continue
;       goto endloop
        jmp endloop
;continue:
continue:
//      e2 = 2*err;
;       a = err
        lda err
;       a = a << 2
        asl
;       e2 = a
        sta e2
//      if (e2 >= dy)
;       a = e2 (opt)
;       if a < dy then goto dyovera
        sec
        sbc dY
        .(:bvc skip : eor #$80: skip:.)
        bmi dyovera
//          err += dy; /* e_xy+e_x > 0 */
;           a = err
            lda err
;           a = a + dy
            clc
            adc dY
;           err = a
            sta err
//          x0 += sx;
;           a = x0
            lda _Point1X
;           a = a + sx
            clc
            adc stepX
;           x0 = a
            sta _Point1X
;dyovera:
dyovera:
//      end if
//      if (e2 <= dx) /* e_xy+e_y < 0 */
;       a = dx
        lda dX
;       if a < e2 then goto e2overdx
        sec
        sbc e2
        bvc*+4
        eor #$80
        bmi e2overdx
//          err += dx;
;           a = err
            lda err
;           a = a + dx
            clc
            adc dX
;           err = a
            sta err
//          y0 += sy;
;           a = y0
            lda _Point1Y
;           a = a + sy
            clc
            adc stepY
;           y0 = a
            sta _Point1Y
//      end if
;e2overdx:
e2overdx:
;   goto drawloop
    jmp drawloop
//  end while
;endloop:
endloop:

	// restore context
	pla:tay:pla:tax:pla

.)
    rts
