#include "config.h"
.zero

ptr_src				.dsb 2

.text 
_clearScreen:
.(
    //jsr $ccee
    
    
//    lda #<$bbaa
//	sta ptr_src+0
//	lda #>$bbaa
//	sta ptr_src+1
//
//	
//	ldx #23
//loop_y	
//	ldy #37
//
//loop_x	
//	lda #$20
//	; Write character in video memory
//	sta (ptr_src),y
//	dey
//	bne loop_x
//
//	clc
//	lda ptr_src+0
//	adc #40
//	sta ptr_src+0
//	bcc skip
//	inc ptr_src+1
//skip		
//	dex
//	bne loop_y

    
    
    
    lda #$20

    ldx #40

clrscrLoop:
    sta ADR_BASE_LORES_SCREEN+SCREEN_WIDTH*0 , x
    sta ADR_BASE_LORES_SCREEN+SCREEN_WIDTH*1 , x
    sta ADR_BASE_LORES_SCREEN+SCREEN_WIDTH*2 , x
    sta ADR_BASE_LORES_SCREEN+SCREEN_WIDTH*3 , x
    sta ADR_BASE_LORES_SCREEN+SCREEN_WIDTH*4 , x
    sta ADR_BASE_LORES_SCREEN+SCREEN_WIDTH*5 , x
    sta ADR_BASE_LORES_SCREEN+SCREEN_WIDTH*6 , x
    sta ADR_BASE_LORES_SCREEN+SCREEN_WIDTH*7 , x
    sta ADR_BASE_LORES_SCREEN+SCREEN_WIDTH*8 , x
    sta ADR_BASE_LORES_SCREEN+SCREEN_WIDTH*9 , x
    sta ADR_BASE_LORES_SCREEN+SCREEN_WIDTH*10 , x
    sta ADR_BASE_LORES_SCREEN+SCREEN_WIDTH*11 , x
    sta ADR_BASE_LORES_SCREEN+SCREEN_WIDTH*12 , x
    sta ADR_BASE_LORES_SCREEN+SCREEN_WIDTH*13 , x
    sta ADR_BASE_LORES_SCREEN+SCREEN_WIDTH*14 , x
    sta ADR_BASE_LORES_SCREEN+SCREEN_WIDTH*15 , x
    sta ADR_BASE_LORES_SCREEN+SCREEN_WIDTH*16 , x
    sta ADR_BASE_LORES_SCREEN+SCREEN_WIDTH*17 , x
    sta ADR_BASE_LORES_SCREEN+SCREEN_WIDTH*18 , x
    sta ADR_BASE_LORES_SCREEN+SCREEN_WIDTH*19 , x
    sta ADR_BASE_LORES_SCREEN+SCREEN_WIDTH*20 , x
    sta ADR_BASE_LORES_SCREEN+SCREEN_WIDTH*21 , x
    sta ADR_BASE_LORES_SCREEN+SCREEN_WIDTH*22 , x
    sta ADR_BASE_LORES_SCREEN+SCREEN_WIDTH*23 , x
    sta ADR_BASE_LORES_SCREEN+SCREEN_WIDTH*24 , x
    sta ADR_BASE_LORES_SCREEN+SCREEN_WIDTH*25 , x
    sta ADR_BASE_LORES_SCREEN+SCREEN_WIDTH*26 , x

    dex
    bne clrscrLoop:
.)
    rts
    
