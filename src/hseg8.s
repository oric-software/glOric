_hfill8
	ldx #7 : lda #5 : jsr enter :
	ldy #4 : lda (ap),y : sta reg0 :
	ldy #6 : lda (ap),y : sta tmp0 : iny : lda (ap),y : sta tmp0+1 :
	lda tmp0 : sta reg1 :
	lda #0 : ldx reg0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #<(0) : cmp tmp0 : lda #>(0) : sbc tmp0+1 : bvc *+4 : eor #$80 : bmi *+5 : jmp JBLmainbis360 : : :
	lda tmp0 : cmp #<(26) : lda tmp0+1 : sbc #>(26) : .( : bvc *+4 : eor #$80 : bpl skip : jmp JBLmainbis358 :skip : .) : :
JBLmainbis360
	jmp leave :
JBLmainbis358
	ldy #0 : ldx #0 : lda (ap),y : sta tmp0 : .( : bpl skip : ldx #$FF :skip : .)  : txa : sta tmp0+1 :
	ldy #2 : ldx #0 : lda (ap),y : sta tmp1 : .( : bpl skip : ldx #$FF :skip : .)  : txa : sta tmp1+1 :
	lda tmp0 : cmp tmp1 : lda tmp0+1 : sbc tmp1+1 : bvc *+4 : eor #$80 : bmi *+5 : jmp JBLmainbis361 : :
	ldy #0 : lda (ap),y : ldy #6 : sta (fp),y :
	ldy #2 : lda (ap),y : sta reg4 :
	jmp JBLmainbis362 :
JBLmainbis361
	ldy #2 : lda (ap),y : ldy #6 : sta (fp),y :
	ldy #0 : lda (ap),y : sta reg4 :
JBLmainbis362
	ldy #6 : lda (fp),y : sta reg2 :
	jmp JBLmainbis366 :
JBLmainbis363
	lda #0 : ldx reg2 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : cmp #<(2) : lda tmp0+1 : sbc #>(2) : .( : bvc *+4 : eor #$80 : bpl skip : jmp JBLmainbis367 :skip : .) : :
	lda #<(40) : cmp tmp0 : lda #>(40) : sbc tmp0+1 : .( : bvc *+4 : eor #$80 : bpl skip : jmp JBLmainbis367 :skip : .) : : :
	lda #0 : ldx reg0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #<(40) : sta op1 : lda #>(40) : sta op1+1 : lda tmp0 : sta op2 : lda tmp0+1 : sta op2+1 : jsr mul16i : stx tmp0 : sta tmp0+1 :
	lda #0 : ldx reg2 : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	clc : lda tmp0 : adc tmp1 : sta reg3 : lda tmp0+1 : adc tmp1+1 : sta reg3+1 :
	lda reg1 : sta tmp0 : lda #0 : sta tmp0+1 :
	clc : lda #<(_zbuffer) : adc reg3 : sta tmp1 : lda #>(_zbuffer) : adc reg3+1 : sta tmp1+1 :
	ldy #0 : lda (tmp1),y : sta tmp1 : lda #0 : sta tmp1+1 :
	lda tmp0 : cmp tmp1 : lda tmp0+1 : sbc tmp1+1 : bvc *+4 : eor #$80 : bmi *+5 : jmp JBLmainbis369 : :
	clc : lda #<(_zbuffer) : adc reg3 : sta tmp0 : lda #>(_zbuffer) : adc reg3+1 : sta tmp0+1 :
	ldy #0 : lda reg1 : sta (tmp0),y :
	clc : lda #<(_fbuffer) : adc reg3 : sta tmp0 : lda #>(_fbuffer) : adc reg3+1 : sta tmp0+1 :
	ldy #8 : lda (ap),y : ldy #0 : sta (tmp0),y :
JBLmainbis369
JBLmainbis367
JBLmainbis364
	lda #0 : ldx reg2 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	inc tmp0 : .( : bne skip : inc tmp0+1 :skip : .)  :
	lda tmp0 : sta reg2 :
JBLmainbis366
	lda #0 : ldx reg2 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx reg4 : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda tmp1 : cmp tmp0 : lda tmp1+1 : sbc tmp0+1 : bvc *+4 : eor #$80 : bmi *+5 : jmp JBLmainbis363 : : :
	jmp leave :
