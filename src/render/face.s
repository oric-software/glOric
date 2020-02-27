#include "config.h"


#ifdef USE_ASM_GUESSIFFACE2BEDRAWN
_guessIfFace2BeDrawn:
.(
	ldx #10 : lda #8 : jsr enter :
	lda _P1AH : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #<(192) : and tmp0 : sta tmp1 : lda #>(192) : and tmp0+1 : sta tmp1+1 :
	lda tmp1 : sta _m1 :
	lda _P2AH : sta tmp1 :
	lda #0 : ldx tmp1 : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda #<(192) : and tmp1 : sta tmp2 : lda #>(192) : and tmp1+1 : sta tmp2+1 :
	lda tmp2 : sta _m2 :
	lda _P3AH : sta tmp2 :
	lda #0 : ldx tmp2 : stx tmp2 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp2+1 :
	lda #<(192) : and tmp2 : sta tmp3 : lda #>(192) : and tmp2+1 : sta tmp3+1 :
	lda tmp3 : sta _m3 :
	lda #<(224) : and tmp0 : sta tmp0 : lda #>(224) : and tmp0+1 : sta tmp0+1 :
	lda tmp0 : sta _v1 :
	lda #<(224) : and tmp1 : sta tmp0 : lda #>(224) : and tmp1+1 : sta tmp0+1 :
	lda tmp0 : sta _v2 :
	lda #<(224) : and tmp2 : sta tmp0 : lda #>(224) : and tmp2+1 : sta tmp0+1 :
	lda tmp0 : sta _v3 :
	lda #<(0) : sta _isFace2BeDrawn :
	lda _m1 : sta tmp0 :
	lda tmp0 : sta tmp0 : lda #0 : sta tmp0+1 :
	lda tmp0 : ora tmp0+1 : bne *+5 : jmp guessIfFace2BeDrawn_LlrsDrawing281 :
	lda #<(192) : eor tmp0 : sta tmp : lda #>(192) : eor tmp0+1 : ora tmp : beq *+5 : jmp guessIfFace2BeDrawn_LlrsDrawing279 :
guessIfFace2BeDrawn_LlrsDrawing281
	lda _v1 : sta tmp0 :
	lda tmp0 : sta tmp0 : lda #0 : sta tmp0+1 :
	lda tmp0 : ora tmp0+1 : bne *+5 : jmp guessIfFace2BeDrawn_LlrsDrawing284 :
	lda #<(224) : eor tmp0 : sta tmp : lda #>(224) : eor tmp0+1 : ora tmp : beq *+5 : jmp guessIfFace2BeDrawn_LlrsDrawing282 :
guessIfFace2BeDrawn_LlrsDrawing284
	lda _P1AH : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #<(128) : and tmp0 : sta tmp0 : lda #>(128) : and tmp0+1 : sta tmp0+1 :
	lda _P2AH : sta tmp1 :
	lda #0 : ldx tmp1 : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda #<(128) : and tmp1 : sta tmp1 : lda #>(128) : and tmp1+1 : sta tmp1+1 :
	lda tmp0 : eor tmp1 : sta tmp : lda tmp0+1 : eor tmp1+1 : ora tmp : beq *+5 : jmp guessIfFace2BeDrawn_LlrsDrawing287 :
	lda _P3AH : sta tmp1 :
	lda #0 : ldx tmp1 : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda #<(128) : and tmp1 : sta tmp1 : lda #>(128) : and tmp1+1 : sta tmp1+1 :
	lda tmp0 : eor tmp1 : sta tmp : lda tmp0+1 : eor tmp1+1 : ora tmp : bne *+5 : jmp guessIfFace2BeDrawn_LlrsDrawing285 :
guessIfFace2BeDrawn_LlrsDrawing287
	lda _P3AH : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : cmp #<(0) : lda tmp0+1 : sbc #>(0) : bvc *+4 : eor #$80 : bmi *+5 : jmp guessIfFace2BeDrawn_LlrsDrawing292 : :
	lda _P3AH : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : sec : sbc tmp0 : sta tmp0 : lda #0 : sbc tmp0+1 : sta tmp0+1 :
	lda tmp0 : sta reg0 : lda tmp0+1 : sta reg0+1 :
	jmp guessIfFace2BeDrawn_LlrsDrawing293 :
guessIfFace2BeDrawn_LlrsDrawing292
	lda _P3AH : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : sta reg0 : lda tmp0+1 : sta reg0+1 :
guessIfFace2BeDrawn_LlrsDrawing293
	lda _P1AH : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : cmp #<(0) : lda tmp0+1 : sbc #>(0) : bvc *+4 : eor #$80 : bmi *+5 : jmp guessIfFace2BeDrawn_LlrsDrawing294 : :
	lda _P1AH : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : sec : sbc tmp0 : sta tmp0 : lda #0 : sbc tmp0+1 : sta tmp0+1 :
	lda tmp0 : sta reg1 : lda tmp0+1 : sta reg1+1 :
	jmp guessIfFace2BeDrawn_LlrsDrawing295 :
guessIfFace2BeDrawn_LlrsDrawing294
	lda _P1AH : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : sta reg1 : lda tmp0+1 : sta reg1+1 :
guessIfFace2BeDrawn_LlrsDrawing295
	lda reg0 : sta tmp0 : lda reg0+1 : sta tmp0+1 :
	lda reg1 : sta tmp1 : lda reg1+1 : sta tmp1+1 :
	sec : lda #<(127) : sbc tmp1 : sta tmp1 : lda #>(127) : sbc tmp1+1 : sta tmp1+1 :
	lda tmp0 : cmp tmp1 : lda tmp0+1 : sbc tmp1+1 : bvc *+4 : eor #$80 : bmi *+5 : jmp guessIfFace2BeDrawn_LlrsDrawing280 : :
	lda #<(1) : sta _isFace2BeDrawn :
	jmp guessIfFace2BeDrawn_LlrsDrawing280 :
guessIfFace2BeDrawn_LlrsDrawing285
	lda #<(1) : sta _isFace2BeDrawn :
	jmp guessIfFace2BeDrawn_LlrsDrawing280 :
guessIfFace2BeDrawn_LlrsDrawing282
	lda _m2 : sta tmp0 :
	lda tmp0 : sta tmp0 : lda #0 : sta tmp0+1 :
	lda tmp0 : ora tmp0+1 : bne *+5 : jmp guessIfFace2BeDrawn_LlrsDrawing298 :
	lda #<(192) : eor tmp0 : sta tmp : lda #>(192) : eor tmp0+1 : ora tmp : beq *+5 : jmp guessIfFace2BeDrawn_LlrsDrawing296 :
guessIfFace2BeDrawn_LlrsDrawing298
	lda _m3 : sta tmp0 :
	lda tmp0 : sta tmp0 : lda #0 : sta tmp0+1 :
	lda tmp0 : ora tmp0+1 : bne *+5 : jmp guessIfFace2BeDrawn_LlrsDrawing301 :
	lda #<(192) : eor tmp0 : sta tmp : lda #>(192) : eor tmp0+1 : ora tmp : beq *+5 : jmp guessIfFace2BeDrawn_LlrsDrawing299 :
guessIfFace2BeDrawn_LlrsDrawing301
	lda _P1AH : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #<(128) : and tmp0 : sta tmp0 : lda #>(128) : and tmp0+1 : sta tmp0+1 :
	lda _P2AH : sta tmp1 :
	lda #0 : ldx tmp1 : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda #<(128) : and tmp1 : sta tmp1 : lda #>(128) : and tmp1+1 : sta tmp1+1 :
	lda tmp0 : eor tmp1 : sta tmp : lda tmp0+1 : eor tmp1+1 : ora tmp : beq *+5 : jmp guessIfFace2BeDrawn_LlrsDrawing304 :
	lda _P3AH : sta tmp1 :
	lda #0 : ldx tmp1 : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda #<(128) : and tmp1 : sta tmp1 : lda #>(128) : and tmp1+1 : sta tmp1+1 :
	lda tmp0 : eor tmp1 : sta tmp : lda tmp0+1 : eor tmp1+1 : ora tmp : bne *+5 : jmp guessIfFace2BeDrawn_LlrsDrawing280 :
guessIfFace2BeDrawn_LlrsDrawing304
	lda #<(1) : sta _isFace2BeDrawn :
	jmp guessIfFace2BeDrawn_LlrsDrawing280 :
guessIfFace2BeDrawn_LlrsDrawing299
	lda _P1AH : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #<(128) : and tmp0 : sta tmp0 : lda #>(128) : and tmp0+1 : sta tmp0+1 :
	lda _P2AH : sta tmp1 :
	lda #0 : ldx tmp1 : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda #<(128) : and tmp1 : sta tmp1 : lda #>(128) : and tmp1+1 : sta tmp1+1 :
	lda tmp0 : eor tmp1 : sta tmp : lda tmp0+1 : eor tmp1+1 : ora tmp : bne *+5 : jmp guessIfFace2BeDrawn_LlrsDrawing305 :
	lda _P2AH : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : cmp #<(0) : lda tmp0+1 : sbc #>(0) : bvc *+4 : eor #$80 : bmi *+5 : jmp guessIfFace2BeDrawn_LlrsDrawing311 : :
	lda _P2AH : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : sec : sbc tmp0 : sta tmp0 : lda #0 : sbc tmp0+1 : sta tmp0+1 :
	lda tmp0 : sta reg2 : lda tmp0+1 : sta reg2+1 :
	jmp guessIfFace2BeDrawn_LlrsDrawing312 :
guessIfFace2BeDrawn_LlrsDrawing311
	lda _P2AH : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : sta reg2 : lda tmp0+1 : sta reg2+1 :
guessIfFace2BeDrawn_LlrsDrawing312
	lda _P1AH : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : cmp #<(0) : lda tmp0+1 : sbc #>(0) : bvc *+4 : eor #$80 : bmi *+5 : jmp guessIfFace2BeDrawn_LlrsDrawing313 : :
	lda _P1AH : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : sec : sbc tmp0 : sta tmp0 : lda #0 : sbc tmp0+1 : sta tmp0+1 :
	lda tmp0 : sta reg3 : lda tmp0+1 : sta reg3+1 :
	jmp guessIfFace2BeDrawn_LlrsDrawing314 :
guessIfFace2BeDrawn_LlrsDrawing313
	lda _P1AH : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : sta reg3 : lda tmp0+1 : sta reg3+1 :
guessIfFace2BeDrawn_LlrsDrawing314
	lda reg2 : sta tmp0 : lda reg2+1 : sta tmp0+1 :
	lda reg3 : sta tmp1 : lda reg3+1 : sta tmp1+1 :
	sec : lda #<(127) : sbc tmp1 : sta tmp1 : lda #>(127) : sbc tmp1+1 : sta tmp1+1 :
	lda tmp0 : cmp tmp1 : lda tmp0+1 : sbc tmp1+1 : bvc *+4 : eor #$80 : bmi *+5 : jmp guessIfFace2BeDrawn_LlrsDrawing306 : :
	lda #<(1) : sta _isFace2BeDrawn :
	jmp guessIfFace2BeDrawn_LlrsDrawing306 :
guessIfFace2BeDrawn_LlrsDrawing305
	lda _P1AH : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #<(128) : and tmp0 : sta tmp0 : lda #>(128) : and tmp0+1 : sta tmp0+1 :
	lda _P3AH : sta tmp1 :
	lda #0 : ldx tmp1 : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda #<(128) : and tmp1 : sta tmp1 : lda #>(128) : and tmp1+1 : sta tmp1+1 :
	lda tmp0 : eor tmp1 : sta tmp : lda tmp0+1 : eor tmp1+1 : ora tmp : bne *+5 : jmp guessIfFace2BeDrawn_LlrsDrawing315 :
	lda _P3AH : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : cmp #<(0) : lda tmp0+1 : sbc #>(0) : bvc *+4 : eor #$80 : bmi *+5 : jmp guessIfFace2BeDrawn_LlrsDrawing321 : :
	lda _P3AH : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : sec : sbc tmp0 : sta tmp0 : lda #0 : sbc tmp0+1 : sta tmp0+1 :
	lda tmp0 : sta reg4 : lda tmp0+1 : sta reg4+1 :
	jmp guessIfFace2BeDrawn_LlrsDrawing322 :
guessIfFace2BeDrawn_LlrsDrawing321
	lda _P3AH : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : sta reg4 : lda tmp0+1 : sta reg4+1 :
guessIfFace2BeDrawn_LlrsDrawing322
	lda _P1AH : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : cmp #<(0) : lda tmp0+1 : sbc #>(0) : bvc *+4 : eor #$80 : bmi *+5 : jmp guessIfFace2BeDrawn_LlrsDrawing323 : :
	lda _P1AH : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : sec : sbc tmp0 : sta tmp0 : lda #0 : sbc tmp0+1 : sta tmp0+1 :
	lda tmp0 : sta reg5 : lda tmp0+1 : sta reg5+1 :
	jmp guessIfFace2BeDrawn_LlrsDrawing324 :
guessIfFace2BeDrawn_LlrsDrawing323
	lda _P1AH : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : sta reg5 : lda tmp0+1 : sta reg5+1 :
guessIfFace2BeDrawn_LlrsDrawing324
	lda reg4 : sta tmp0 : lda reg4+1 : sta tmp0+1 :
	lda reg5 : sta tmp1 : lda reg5+1 : sta tmp1+1 :
	sec : lda #<(127) : sbc tmp1 : sta tmp1 : lda #>(127) : sbc tmp1+1 : sta tmp1+1 :
	lda tmp0 : cmp tmp1 : lda tmp0+1 : sbc tmp1+1 : bvc *+4 : eor #$80 : bmi *+5 : jmp guessIfFace2BeDrawn_LlrsDrawing317 : :
	lda #<(1) : sta _isFace2BeDrawn :
guessIfFace2BeDrawn_LlrsDrawing317
guessIfFace2BeDrawn_LlrsDrawing315
guessIfFace2BeDrawn_LlrsDrawing306
	lda _P1AH : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #<(128) : and tmp0 : sta tmp0 : lda #>(128) : and tmp0+1 : sta tmp0+1 :
	lda _P3AH : sta tmp1 :
	lda #0 : ldx tmp1 : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda #<(128) : and tmp1 : sta tmp1 : lda #>(128) : and tmp1+1 : sta tmp1+1 :
	lda tmp0 : eor tmp1 : sta tmp : lda tmp0+1 : eor tmp1+1 : ora tmp : bne *+5 : jmp guessIfFace2BeDrawn_LlrsDrawing280 :
	lda _P3AH : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : cmp #<(0) : lda tmp0+1 : sbc #>(0) : bvc *+4 : eor #$80 : bmi *+5 : jmp guessIfFace2BeDrawn_LlrsDrawing331 : :
	lda _P3AH : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : sec : sbc tmp0 : sta tmp0 : lda #0 : sbc tmp0+1 : sta tmp0+1 :
	lda tmp0 : sta reg6 : lda tmp0+1 : sta reg6+1 :
	jmp guessIfFace2BeDrawn_LlrsDrawing332 :
guessIfFace2BeDrawn_LlrsDrawing331
	lda _P3AH : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : sta reg6 : lda tmp0+1 : sta reg6+1 :
guessIfFace2BeDrawn_LlrsDrawing332
	lda _P1AH : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : cmp #<(0) : lda tmp0+1 : sbc #>(0) : bvc *+4 : eor #$80 : bmi *+5 : jmp guessIfFace2BeDrawn_LlrsDrawing333 : :
	lda _P1AH : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : sec : sbc tmp0 : sta tmp0 : lda #0 : sbc tmp0+1 : sta tmp0+1 :
	lda tmp0 : sta reg7 : lda tmp0+1 : sta reg7+1 :
	jmp guessIfFace2BeDrawn_LlrsDrawing334 :
guessIfFace2BeDrawn_LlrsDrawing333
	lda _P1AH : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : sta reg7 : lda tmp0+1 : sta reg7+1 :
guessIfFace2BeDrawn_LlrsDrawing334
	lda reg6 : sta tmp0 : lda reg6+1 : sta tmp0+1 :
	lda reg7 : sta tmp1 : lda reg7+1 : sta tmp1+1 :
	sec : lda #<(127) : sbc tmp1 : sta tmp1 : lda #>(127) : sbc tmp1+1 : sta tmp1+1 :
	lda tmp0 : cmp tmp1 : lda tmp0+1 : sbc tmp1+1 : bvc *+4 : eor #$80 : bmi *+5 : jmp guessIfFace2BeDrawn_LlrsDrawing280 : :
	lda #<(1) : sta _isFace2BeDrawn :
	jmp guessIfFace2BeDrawn_LlrsDrawing280 :
guessIfFace2BeDrawn_LlrsDrawing296
	lda _P1AH : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #<(128) : and tmp0 : sta tmp0 : lda #>(128) : and tmp0+1 : sta tmp0+1 :
	lda _P2AH : sta tmp1 :
	lda #0 : ldx tmp1 : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda #<(128) : and tmp1 : sta tmp1 : lda #>(128) : and tmp1+1 : sta tmp1+1 :
	lda tmp0 : eor tmp1 : sta tmp : lda tmp0+1 : eor tmp1+1 : ora tmp : bne *+5 : jmp guessIfFace2BeDrawn_LlrsDrawing335 :
	lda _P2AH : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : cmp #<(0) : lda tmp0+1 : sbc #>(0) : bvc *+4 : eor #$80 : bmi *+5 : jmp guessIfFace2BeDrawn_LlrsDrawing341 : :
	lda _P2AH : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : sec : sbc tmp0 : sta tmp0 : lda #0 : sbc tmp0+1 : sta tmp0+1 :
	ldy #6 : lda tmp0 : sta (fp),y : iny : lda tmp0+1 : sta (fp),y :
	jmp guessIfFace2BeDrawn_LlrsDrawing342 :
guessIfFace2BeDrawn_LlrsDrawing341
	lda _P2AH : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	ldy #6 : lda tmp0 : sta (fp),y : iny : lda tmp0+1 : sta (fp),y :
guessIfFace2BeDrawn_LlrsDrawing342
	lda _P1AH : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : cmp #<(0) : lda tmp0+1 : sbc #>(0) : bvc *+4 : eor #$80 : bmi *+5 : jmp guessIfFace2BeDrawn_LlrsDrawing343 : :
	lda _P1AH : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : sec : sbc tmp0 : sta tmp0 : lda #0 : sbc tmp0+1 : sta tmp0+1 :
	ldy #8 : lda tmp0 : sta (fp),y : iny : lda tmp0+1 : sta (fp),y :
	jmp guessIfFace2BeDrawn_LlrsDrawing344 :
guessIfFace2BeDrawn_LlrsDrawing343
	lda _P1AH : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	ldy #8 : lda tmp0 : sta (fp),y : iny : lda tmp0+1 : sta (fp),y :
guessIfFace2BeDrawn_LlrsDrawing344
	ldy #6 : lda (fp),y : sta tmp0 : iny : lda (fp),y : sta tmp0+1 :
	ldy #8 : lda (fp),y : sta tmp1 : iny : lda (fp),y : sta tmp1+1 :
	sec : lda #<(127) : sbc tmp1 : sta tmp1 : lda #>(127) : sbc tmp1+1 : sta tmp1+1 :
	lda tmp0 : cmp tmp1 : lda tmp0+1 : sbc tmp1+1 : bvc *+4 : eor #$80 : bmi *+5 : jmp guessIfFace2BeDrawn_LlrsDrawing336 : :
	lda #<(1) : sta _isFace2BeDrawn :
	jmp guessIfFace2BeDrawn_LlrsDrawing336 :
guessIfFace2BeDrawn_LlrsDrawing335
	lda _P1AH : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #<(128) : and tmp0 : sta tmp0 : lda #>(128) : and tmp0+1 : sta tmp0+1 :
	lda _P3AH : sta tmp1 :
	lda #0 : ldx tmp1 : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda #<(128) : and tmp1 : sta tmp1 : lda #>(128) : and tmp1+1 : sta tmp1+1 :
	lda tmp0 : eor tmp1 : sta tmp : lda tmp0+1 : eor tmp1+1 : ora tmp : bne *+5 : jmp guessIfFace2BeDrawn_LlrsDrawing345 :
	lda _P3AH : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : cmp #<(0) : lda tmp0+1 : sbc #>(0) : bvc *+4 : eor #$80 : bmi *+5 : jmp guessIfFace2BeDrawn_LlrsDrawing351 : :
	lda _P3AH : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : sec : sbc tmp0 : sta tmp0 : lda #0 : sbc tmp0+1 : sta tmp0+1 :
	ldy #6 : lda tmp0 : sta (fp),y : iny : lda tmp0+1 : sta (fp),y :
	jmp guessIfFace2BeDrawn_LlrsDrawing352 :
guessIfFace2BeDrawn_LlrsDrawing351
	lda _P3AH : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	ldy #6 : lda tmp0 : sta (fp),y : iny : lda tmp0+1 : sta (fp),y :
guessIfFace2BeDrawn_LlrsDrawing352
	lda _P1AH : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : cmp #<(0) : lda tmp0+1 : sbc #>(0) : bvc *+4 : eor #$80 : bmi *+5 : jmp guessIfFace2BeDrawn_LlrsDrawing353 : :
	lda _P1AH : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : sec : sbc tmp0 : sta tmp0 : lda #0 : sbc tmp0+1 : sta tmp0+1 :
	ldy #8 : lda tmp0 : sta (fp),y : iny : lda tmp0+1 : sta (fp),y :
	jmp guessIfFace2BeDrawn_LlrsDrawing354 :
guessIfFace2BeDrawn_LlrsDrawing353
	lda _P1AH : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	ldy #8 : lda tmp0 : sta (fp),y : iny : lda tmp0+1 : sta (fp),y :
guessIfFace2BeDrawn_LlrsDrawing354
	ldy #6 : lda (fp),y : sta tmp0 : iny : lda (fp),y : sta tmp0+1 :
	ldy #8 : lda (fp),y : sta tmp1 : iny : lda (fp),y : sta tmp1+1 :
	sec : lda #<(127) : sbc tmp1 : sta tmp1 : lda #>(127) : sbc tmp1+1 : sta tmp1+1 :
	lda tmp0 : cmp tmp1 : lda tmp0+1 : sbc tmp1+1 : bvc *+4 : eor #$80 : bmi *+5 : jmp guessIfFace2BeDrawn_LlrsDrawing347 : :
	lda #<(1) : sta _isFace2BeDrawn :
guessIfFace2BeDrawn_LlrsDrawing347
guessIfFace2BeDrawn_LlrsDrawing345
guessIfFace2BeDrawn_LlrsDrawing336
	lda _P1AH : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #<(128) : and tmp0 : sta tmp0 : lda #>(128) : and tmp0+1 : sta tmp0+1 :
	lda _P3AH : sta tmp1 :
	lda #0 : ldx tmp1 : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda #<(128) : and tmp1 : sta tmp1 : lda #>(128) : and tmp1+1 : sta tmp1+1 :
	lda tmp0 : eor tmp1 : sta tmp : lda tmp0+1 : eor tmp1+1 : ora tmp : bne *+5 : jmp guessIfFace2BeDrawn_LlrsDrawing280 :
	lda _P3AH : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : cmp #<(0) : lda tmp0+1 : sbc #>(0) : bvc *+4 : eor #$80 : bmi *+5 : jmp guessIfFace2BeDrawn_LlrsDrawing361 : :
	lda _P3AH : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : sec : sbc tmp0 : sta tmp0 : lda #0 : sbc tmp0+1 : sta tmp0+1 :
	ldy #6 : lda tmp0 : sta (fp),y : iny : lda tmp0+1 : sta (fp),y :
	jmp guessIfFace2BeDrawn_LlrsDrawing362 :
guessIfFace2BeDrawn_LlrsDrawing361
	lda _P3AH : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	ldy #6 : lda tmp0 : sta (fp),y : iny : lda tmp0+1 : sta (fp),y :
guessIfFace2BeDrawn_LlrsDrawing362
	lda _P1AH : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : cmp #<(0) : lda tmp0+1 : sbc #>(0) : bvc *+4 : eor #$80 : bmi *+5 : jmp guessIfFace2BeDrawn_LlrsDrawing363 : :
	lda _P1AH : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : sec : sbc tmp0 : sta tmp0 : lda #0 : sbc tmp0+1 : sta tmp0+1 :
	ldy #8 : lda tmp0 : sta (fp),y : iny : lda tmp0+1 : sta (fp),y :
	jmp guessIfFace2BeDrawn_LlrsDrawing364 :
guessIfFace2BeDrawn_LlrsDrawing363
	lda _P1AH : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	ldy #8 : lda tmp0 : sta (fp),y : iny : lda tmp0+1 : sta (fp),y :
guessIfFace2BeDrawn_LlrsDrawing364
	ldy #6 : lda (fp),y : sta tmp0 : iny : lda (fp),y : sta tmp0+1 :
	ldy #8 : lda (fp),y : sta tmp1 : iny : lda (fp),y : sta tmp1+1 :
	sec : lda #<(127) : sbc tmp1 : sta tmp1 : lda #>(127) : sbc tmp1+1 : sta tmp1+1 :
	lda tmp0 : cmp tmp1 : lda tmp0+1 : sbc tmp1+1 : bvc *+4 : eor #$80 : bmi *+5 : jmp guessIfFace2BeDrawn_LlrsDrawing280 : :
	lda #<(1) : sta _isFace2BeDrawn :
guessIfFace2BeDrawn_LlrsDrawing279
guessIfFace2BeDrawn_LlrsDrawing280
	jmp leave :

.)
    rts
#endif