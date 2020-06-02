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


#endif ;; USE_ASM_BUFFER2SCREEN
