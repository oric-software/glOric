_A1X
	.byt 0
_A1Y
	.byt 0
_A1destX
	.byt 0
_A1destY
	.byt 0
_A1dX
	.byt 0
_A1dY
	.byt 0
_A1err
	.byt 0
_A1sX
	.byt 0
_A1sY
	.byt 0
_A1arrived
	.byt 0
_A2X
	.byt 0
_A2Y
	.byt 0
_A2destX
	.byt 0
_A2destY
	.byt 0
_A2dX
	.byt 0
_A2dY
	.byt 0
_A2err
	.byt 0
_A2sX
	.byt 0
_A2sY
	.byt 0
_A2arrived
	.byt 0
	
	
_A1stepY
.(
	// save context
    pha
	lda reg0: pha: lda reg1 : pha 

	;; nxtY = A1Y+A1sY;
	clc
	lda _A1Y
	adc _A1sY
	sta reg1
	
	;; e2 = A1err << 1; // 2*A1err;
	lda _A1err
	asl
	sta reg0
	
	;; while ((A1arrived == 0) && ((e2>A1dX) || (A1Y!=nxtY))){
A1stepY_loop:
	lda _A1arrived ;; (A1arrived == 0)
	bne A1stepYdone
	
	lda _A1dX 		;; (e2>A1dX)
	cmp reg0
	bmi A1stepY_doloop

	lda reg1 		;; (A1Y!=nxtY)
	cmp _A1Y
	bne A1stepY_doloop
	
	jmp A1stepYdone
A1stepY_doloop:
	
		;; if (e2 >= A1dY){
		lda reg0 ; e2
		cmp _A1dY
		bmi A1stepY_A1Xdone
		;; 	A1err += A1dY;
			clc
			lda _A1err
			adc _A1dY
			sta _A1err
		;; 	A1X += A1sX;
			clc
			lda _A1X
			adc _A1sX
			sta _A1X
		;; }
A1stepY_A1Xdone:
		;; if (e2 <= A1dX){
		lda _A1dX
		cmp reg0
		bmi A1stepY_A1Ydone
		;; 	A1err += A1dX;
			clc
			lda _A1err
			adc _A1dX
			sta _A1err
		;; 	A1Y += A1sY; // TODO : can be optimized by dec _A1Y
			dec _A1Y
			;clc
			;lda _A1Y
			;adc _A1sY
			;sta _A1Y
			
		;; }
A1stepY_A1Ydone:
		;; A1arrived=((A1X == A1destX) && ( A1Y == A1destY))?1:0;
		lda #0
		sta _A1arrived
		
		lda _A1X
		cmp _A1destX
		bne A1stepY_computeE2
		
		lda _A1Y
		cmp _A1destY
		bne A1stepY_computeE2
	
		lda #1
		sta _A1arrived
A1stepY_computeE2:
		;; e2 = A1err << 1; // 2*A1err;
		lda _A1err
		asl
		sta reg0
	
	jmp A1stepY_loop
A1stepYdone:	

	// restore context
	pla: sta reg1: pla: sta reg0
	pla

.)
	rts

_A1stepY2
.(
	ldx #6 : lda #3 : jsr enter :
	lda #0 : ldx _A1Y : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A1sY : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	clc : lda tmp0 : adc tmp1 : sta tmp0 : lda tmp0+1 : adc tmp1+1 : sta tmp0+1 :
	lda tmp0 : sta reg1 :
	lda #0 : ldx _A1err : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : asl : sta tmp0 : lda tmp0+1 : rol : sta tmp0+1 :
	lda tmp0 : sta reg0 :
	jmp JBLmain337 :
JBLmain336
	lda #0 : ldx reg0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A1dY : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda tmp0 : cmp tmp1 : lda tmp0+1 : sbc tmp1+1 : .( : bvc *+4 : eor #$80 : bpl skip : jmp JBLmain339 :skip : .) : :
	lda #0 : ldx _A1err : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A1dY : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	clc : lda tmp0 : adc tmp1 : sta tmp0 : lda tmp0+1 : adc tmp1+1 : sta tmp0+1 :
	lda tmp0 : sta _A1err :
	lda #0 : ldx _A1X : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A1sX : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	clc : lda tmp0 : adc tmp1 : sta tmp0 : lda tmp0+1 : adc tmp1+1 : sta tmp0+1 :
	lda tmp0 : sta _A1X :
JBLmain339
	lda #0 : ldx reg0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A1dX : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda tmp1 : cmp tmp0 : lda tmp1+1 : sbc tmp0+1 : .( : bvc *+4 : eor #$80 : bpl skip : jmp JBLmain341 :skip : .) : : :
	lda #0 : ldx _A1err : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A1dX : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	clc : lda tmp0 : adc tmp1 : sta tmp0 : lda tmp0+1 : adc tmp1+1 : sta tmp0+1 :
	lda tmp0 : sta _A1err :
	lda #0 : ldx _A1Y : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A1sY : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	clc : lda tmp0 : adc tmp1 : sta tmp0 : lda tmp0+1 : adc tmp1+1 : sta tmp0+1 :
	lda tmp0 : sta _A1Y :
JBLmain341
	lda #0 : ldx _A1X : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A1destX : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda tmp0 : eor tmp1 : sta tmp : lda tmp0+1 : eor tmp1+1 : ora tmp : beq *+5 : jmp JBLmain344 :
	lda #0 : ldx _A1Y : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A1destY : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda tmp0 : eor tmp1 : sta tmp : lda tmp0+1 : eor tmp1+1 : ora tmp : beq *+5 : jmp JBLmain344 :
	lda #<(1) : sta reg2 : lda #>(1) : sta reg2+1 :
	jmp JBLmain345 :
JBLmain344
	lda #<(0) : sta reg2 : lda #>(0) : sta reg2+1 :
JBLmain345
	lda reg2 : sta _A1arrived :
	lda #0 : ldx _A1err : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : asl : sta tmp0 : lda tmp0+1 : rol : sta tmp0+1 :
	lda tmp0 : sta reg0 :
JBLmain337
	lda #0 : ldx _A1arrived : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : ora tmp0+1 : beq *+5 : jmp JBLmain346 :
	lda #0 : ldx reg0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A1dX : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda tmp1 : cmp tmp0 : lda tmp1+1 : sbc tmp0+1 : .( : bvc *+4 : eor #$80 : bpl skip : jmp JBLmain336 :skip : .) : : :
	lda #0 : ldx _A1Y : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx reg1 : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda tmp0 : eor tmp1 : sta tmp : lda tmp0+1 : eor tmp1+1 : ora tmp : beq *+5 : jmp JBLmain336 :
JBLmain346
.)
	jmp leave :
	
	
_A2stepY
.(
	// save context
    pha
	lda reg0: pha: lda reg1 : pha 

	;; nxtY = A2Y+A2sY;
	clc
	lda _A2Y
	adc _A2sY
	sta reg1
	
	;; e2 = A2err << 1; // 2*A2err;
	lda _A2err
	asl
	sta reg0
	
	;; while ((A2arrived == 0) && ((e2>A2dX) || (A2Y!=nxtY))){
A2stepY_loop:
	lda _A2arrived ;; (A2arrived == 0)
	bne A2stepYdone
	
	lda _A2dX 		;; (e2>A2dX)
	cmp reg0
	bmi A2stepY_doloop

	lda reg1 		;; (A2Y!=nxtY)
	cmp _A2Y
	bne A2stepY_doloop
	
	jmp A2stepYdone
A2stepY_doloop:
	
		;; if (e2 >= A2dY){
		lda reg0 ; e2
		cmp _A2dY
		bmi A2stepY_A2Xdone
		;; 	A2err += A2dY;
			clc
			lda _A2err
			adc _A2dY
			sta _A2err
		;; 	A2X += A2sX;
			clc
			lda _A2X
			adc _A2sX
			sta _A2X
		;; }
A2stepY_A2Xdone:
		;; if (e2 <= A2dX){
		lda _A2dX
		cmp reg0
		bmi A2stepY_A2Ydone
		;; 	A2err += A2dX;
			clc
			lda _A2err
			adc _A2dX
			sta _A2err
		;; 	A2Y += A2sY; // TODO : can be optimized by dec _A2Y
			dec _A2Y
			;clc
			;lda _A2Y
			;adc _A2sY
			;sta _A2Y
			
		;; }
A2stepY_A2Ydone:
		;; A2arrived=((A2X == A2destX) && ( A2Y == A2destY))?1:0;
		lda #0
		sta _A2arrived
		
		lda _A2X
		cmp _A2destX
		bne A2stepY_computeE2
		
		lda _A2Y
		cmp _A2destY
		bne A2stepY_computeE2
	
		lda #1
		sta _A2arrived
A2stepY_computeE2:
		;; e2 = A2err << 1; // 2*A2err;
		lda _A2err
		asl
		sta reg0
	
	jmp A2stepY_loop
A2stepYdone:	

	// restore context
	pla: sta reg1: pla: sta reg0
	pla

.)
	rts
	
	
_A2stepY2
.(
	ldx #6 : lda #3 : jsr enter :
	lda #0 : ldx _A2Y : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A2sY : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	clc : lda tmp0 : adc tmp1 : sta tmp0 : lda tmp0+1 : adc tmp1+1 : sta tmp0+1 :
	lda tmp0 : sta reg1 :
	lda #0 : ldx _A2err : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : asl : sta tmp0 : lda tmp0+1 : rol : sta tmp0+1 :
	lda tmp0 : sta reg0 :
	jmp JBLmain348 :
JBLmain347
	lda #0 : ldx reg0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A2dY : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda tmp0 : cmp tmp1 : lda tmp0+1 : sbc tmp1+1 : .( : bvc *+4 : eor #$80 : bpl skip : jmp JBLmain350 :skip : .) : :
	lda #0 : ldx _A2err : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A2dY : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	clc : lda tmp0 : adc tmp1 : sta tmp0 : lda tmp0+1 : adc tmp1+1 : sta tmp0+1 :
	lda tmp0 : sta _A2err :
	lda #0 : ldx _A2X : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A2sX : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	clc : lda tmp0 : adc tmp1 : sta tmp0 : lda tmp0+1 : adc tmp1+1 : sta tmp0+1 :
	lda tmp0 : sta _A2X :
JBLmain350
	lda #0 : ldx reg0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A2dX : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda tmp1 : cmp tmp0 : lda tmp1+1 : sbc tmp0+1 : .( : bvc *+4 : eor #$80 : bpl skip : jmp JBLmain352 :skip : .) : : :
	lda #0 : ldx _A2err : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A2dX : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	clc : lda tmp0 : adc tmp1 : sta tmp0 : lda tmp0+1 : adc tmp1+1 : sta tmp0+1 :
	lda tmp0 : sta _A2err :
	lda #0 : ldx _A2Y : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A2sY : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	clc : lda tmp0 : adc tmp1 : sta tmp0 : lda tmp0+1 : adc tmp1+1 : sta tmp0+1 :
	lda tmp0 : sta _A2Y :
JBLmain352
	lda #0 : ldx _A2X : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A2destX : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda tmp0 : eor tmp1 : sta tmp : lda tmp0+1 : eor tmp1+1 : ora tmp : beq *+5 : jmp JBLmain355 :
	lda #0 : ldx _A2Y : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A2destY : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda tmp0 : eor tmp1 : sta tmp : lda tmp0+1 : eor tmp1+1 : ora tmp : beq *+5 : jmp JBLmain355 :
	lda #<(1) : sta reg2 : lda #>(1) : sta reg2+1 :
	jmp JBLmain356 :
JBLmain355
	lda #<(0) : sta reg2 : lda #>(0) : sta reg2+1 :
JBLmain356
	lda reg2 : sta _A2arrived :
	lda #0 : ldx _A2err : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : asl : sta tmp0 : lda tmp0+1 : rol : sta tmp0+1 :
	lda tmp0 : sta reg0 :
JBLmain348
	lda #0 : ldx _A2arrived : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : ora tmp0+1 : beq *+5 : jmp JBLmain357 :
	lda #0 : ldx reg0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A2dX : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda tmp1 : cmp tmp0 : lda tmp1+1 : sbc tmp0+1 : .( : bvc *+4 : eor #$80 : bpl skip : jmp JBLmain347 :skip : .) : : :
	lda #0 : ldx _A2Y : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx reg1 : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda tmp0 : eor tmp1 : sta tmp : lda tmp0+1 : eor tmp1+1 : ora tmp : beq *+5 : jmp JBLmain347 :
JBLmain357
.)
	jmp leave :


/*
_fill8_bis
.(
	ldx #10 : lda #8 : jsr enter :
	ldy #12 : lda (ap),y : sta tmp0 : iny : lda (ap),y : sta tmp0+1 :
	lda tmp0 : sta reg0 :
	ldy #14 : lda (ap),y : sta reg1 :
	ldy #2 : ldx #0 : lda (ap),y : sta tmp0 : .( : bpl skip : ldx #$FF :skip : .)  : txa : sta tmp0+1 :
	ldy #6 : ldx #0 : lda (ap),y : sta tmp1 : .( : bpl skip : ldx #$FF :skip : .)  : txa : sta tmp1+1 :
	lda tmp1 : cmp tmp0 : lda tmp1+1 : sbc tmp0+1 : .( : bvc *+4 : eor #$80 : bpl skip : jmp JBLmain358 :skip : .) : : :
	ldy #6 : ldx #0 : lda (ap),y : sta tmp0 : .( : bpl skip : ldx #$FF :skip : .)  : txa : sta tmp0+1 :
	ldy #10 : ldx #0 : lda (ap),y : sta tmp1 : .( : bpl skip : ldx #$FF :skip : .)  : txa : sta tmp1+1 :
	lda tmp1 : cmp tmp0 : lda tmp1+1 : sbc tmp0+1 : .( : bvc *+4 : eor #$80 : bpl skip : jmp JBLmain360 :skip : .) : : :
	ldy #8 : lda (ap),y : ldy #6 : sta (fp),y :
	ldy #10 : lda (ap),y : sta reg2 :
	ldy #4 : lda (ap),y : ldy #7 : sta (fp),y :
	ldy #6 : lda (ap),y : sta reg3 :
	ldy #0 : lda (ap),y : sta reg4 :
	ldy #2 : lda (ap),y : sta reg5 :
	jmp JBLmain359 :
JBLmain360
	ldy #4 : lda (ap),y : ldy #6 : sta (fp),y :
	ldy #6 : lda (ap),y : sta reg2 :
	ldy #2 : ldx #0 : lda (ap),y : sta tmp0 : .( : bpl skip : ldx #$FF :skip : .)  : txa : sta tmp0+1 :
	ldy #10 : ldx #0 : lda (ap),y : sta tmp1 : .( : bpl skip : ldx #$FF :skip : .)  : txa : sta tmp1+1 :
	lda tmp1 : cmp tmp0 : lda tmp1+1 : sbc tmp0+1 : .( : bvc *+4 : eor #$80 : bpl skip : jmp JBLmain362 :skip : .) : : :
	ldy #8 : lda (ap),y : ldy #7 : sta (fp),y :
	ldy #10 : lda (ap),y : sta reg3 :
	ldy #0 : lda (ap),y : sta reg4 :
	ldy #2 : lda (ap),y : sta reg5 :
	jmp JBLmain359 :
JBLmain362
	ldy #0 : lda (ap),y : ldy #7 : sta (fp),y :
	ldy #2 : lda (ap),y : sta reg3 :
	ldy #8 : lda (ap),y : sta reg4 :
	ldy #10 : lda (ap),y : sta reg5 :
	jmp JBLmain359 :
JBLmain358
	ldy #2 : ldx #0 : lda (ap),y : sta tmp0 : .( : bpl skip : ldx #$FF :skip : .)  : txa : sta tmp0+1 :
	ldy #10 : ldx #0 : lda (ap),y : sta tmp1 : .( : bpl skip : ldx #$FF :skip : .)  : txa : sta tmp1+1 :
	lda tmp1 : cmp tmp0 : lda tmp1+1 : sbc tmp0+1 : .( : bvc *+4 : eor #$80 : bpl skip : jmp JBLmain364 :skip : .) : : :
	ldy #8 : lda (ap),y : ldy #6 : sta (fp),y :
	ldy #10 : lda (ap),y : sta reg2 :
	ldy #0 : lda (ap),y : ldy #7 : sta (fp),y :
	ldy #2 : lda (ap),y : sta reg3 :
	ldy #4 : lda (ap),y : sta reg4 :
	ldy #6 : lda (ap),y : sta reg5 :
	jmp JBLmain365 :
JBLmain364
	ldy #0 : lda (ap),y : ldy #6 : sta (fp),y :
	ldy #2 : lda (ap),y : sta reg2 :
	ldy #6 : ldx #0 : lda (ap),y : sta tmp0 : .( : bpl skip : ldx #$FF :skip : .)  : txa : sta tmp0+1 :
	ldy #10 : ldx #0 : lda (ap),y : sta tmp1 : .( : bpl skip : ldx #$FF :skip : .)  : txa : sta tmp1+1 :
	lda tmp1 : cmp tmp0 : lda tmp1+1 : sbc tmp0+1 : .( : bvc *+4 : eor #$80 : bpl skip : jmp JBLmain366 :skip : .) : : :
	ldy #8 : lda (ap),y : ldy #7 : sta (fp),y :
	ldy #10 : lda (ap),y : sta reg3 :
	ldy #4 : lda (ap),y : sta reg4 :
	ldy #6 : lda (ap),y : sta reg5 :
	jmp JBLmain367 :
JBLmain366
	ldy #4 : lda (ap),y : ldy #7 : sta (fp),y :
	ldy #6 : lda (ap),y : sta reg3 :
	ldy #8 : lda (ap),y : sta reg4 :
	ldy #10 : lda (ap),y : sta reg5 :
JBLmain367
JBLmain365
JBLmain359
	lda #0 : ldx reg2 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx reg3 : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda tmp0 : eor tmp1 : sta tmp : lda tmp0+1 : eor tmp1+1 : ora tmp : bne *+5 : jmp JBLmain368 :
	ldy #6 : lda (fp),y : sta _A1X :
	lda reg2 : sta _A1Y :
	ldy #7 : lda (fp),y : sta _A1destX :
	lda reg3 : sta _A1destY :
	lda #0 : ldx _A1destX : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A1X : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	sec : lda tmp0 : sbc tmp1 : sta tmp0 : lda tmp0+1 : sbc tmp1+1 : sta tmp0+1 :
	lda tmp0 : cmp #<(0) : lda tmp0+1 : sbc #>(0) : bvc *+4 : eor #$80 : bmi *+5 : jmp JBLmain371 : :
	lda #0 : ldx _A1destX : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A1X : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	sec : lda tmp0 : sbc tmp1 : sta tmp0 : lda tmp0+1 : sbc tmp1+1 : sta tmp0+1 :
	lda #0 : sec : sbc tmp0 : sta reg6 : lda #0 : sbc tmp0+1 : sta reg6+1 :
	jmp JBLmain372 :
JBLmain371
	lda #0 : ldx _A1destX : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A1X : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	sec : lda tmp0 : sbc tmp1 : sta reg6 : lda tmp0+1 : sbc tmp1+1 : sta reg6+1 :
JBLmain372
	lda reg6 : sta _A1dX :
	lda #0 : ldx _A1destY : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A1Y : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	sec : lda tmp0 : sbc tmp1 : sta tmp0 : lda tmp0+1 : sbc tmp1+1 : sta tmp0+1 :
	lda tmp0 : cmp #<(0) : lda tmp0+1 : sbc #>(0) : bvc *+4 : eor #$80 : bmi *+5 : jmp JBLmain373 : :
	lda #0 : ldx _A1destY : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A1Y : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	sec : lda tmp0 : sbc tmp1 : sta tmp0 : lda tmp0+1 : sbc tmp1+1 : sta tmp0+1 :
	lda #0 : sec : sbc tmp0 : sta reg6 : lda #0 : sbc tmp0+1 : sta reg6+1 :
	jmp JBLmain374 :
JBLmain373
	lda #0 : ldx _A1destY : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A1Y : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	sec : lda tmp0 : sbc tmp1 : sta reg6 : lda tmp0+1 : sbc tmp1+1 : sta reg6+1 :
JBLmain374
	lda #0 : sec : sbc reg6 : sta tmp0 : lda #0 : sbc reg6+1 : sta tmp0+1 :
	lda tmp0 : sta _A1dY :
	lda #0 : ldx _A1dX : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A1dY : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	clc : lda tmp0 : adc tmp1 : sta tmp0 : lda tmp0+1 : adc tmp1+1 : sta tmp0+1 :
	lda tmp0 : sta _A1err :
	lda #0 : ldx _A1X : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A1destX : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda tmp0 : cmp tmp1 : lda tmp0+1 : sbc tmp1+1 : bvc *+4 : eor #$80 : bmi *+5 : jmp JBLmain375 : :
	lda #<(1) : sta reg6 : lda #>(1) : sta reg6+1 :
	jmp JBLmain376 :
JBLmain375
	lda #<(-1) : sta reg6 : lda #>(-1) : sta reg6+1 :
JBLmain376
	lda reg6 : sta _A1sX :
	lda #0 : ldx _A1Y : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A1destY : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda tmp0 : cmp tmp1 : lda tmp0+1 : sbc tmp1+1 : bvc *+4 : eor #$80 : bmi *+5 : jmp JBLmain377 : :
	lda #<(1) : sta reg6 : lda #>(1) : sta reg6+1 :
	jmp JBLmain378 :
JBLmain377
	lda #<(-1) : sta reg6 : lda #>(-1) : sta reg6+1 :
JBLmain378
	lda reg6 : sta _A1sY :
	lda #0 : ldx _A1X : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A1destX : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda tmp0 : eor tmp1 : sta tmp : lda tmp0+1 : eor tmp1+1 : ora tmp : beq *+5 : jmp JBLmain379 :
	lda #0 : ldx _A1Y : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A1destY : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda tmp0 : eor tmp1 : sta tmp : lda tmp0+1 : eor tmp1+1 : ora tmp : beq *+5 : jmp JBLmain379 :
	lda #<(1) : sta reg6 : lda #>(1) : sta reg6+1 :
	jmp JBLmain380 :
JBLmain379
	lda #<(0) : sta reg6 : lda #>(0) : sta reg6+1 :
JBLmain380
	lda reg6 : sta _A1arrived :
	ldy #6 : lda (fp),y : sta _A2X :
	lda reg2 : sta _A2Y :
	lda reg4 : sta _A2destX :
	lda reg5 : sta _A2destY :
	lda #0 : ldx _A2destX : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A2X : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	sec : lda tmp0 : sbc tmp1 : sta tmp0 : lda tmp0+1 : sbc tmp1+1 : sta tmp0+1 :
	lda tmp0 : cmp #<(0) : lda tmp0+1 : sbc #>(0) : bvc *+4 : eor #$80 : bmi *+5 : jmp JBLmain381 : :
	lda #0 : ldx _A2destX : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A2X : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	sec : lda tmp0 : sbc tmp1 : sta tmp0 : lda tmp0+1 : sbc tmp1+1 : sta tmp0+1 :
	lda #0 : sec : sbc tmp0 : sta reg6 : lda #0 : sbc tmp0+1 : sta reg6+1 :
	jmp JBLmain382 :
JBLmain381
	lda #0 : ldx _A2destX : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A2X : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	sec : lda tmp0 : sbc tmp1 : sta reg6 : lda tmp0+1 : sbc tmp1+1 : sta reg6+1 :
JBLmain382
	lda reg6 : sta _A2dX :
	lda #0 : ldx _A2destY : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A2Y : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	sec : lda tmp0 : sbc tmp1 : sta tmp0 : lda tmp0+1 : sbc tmp1+1 : sta tmp0+1 :
	lda tmp0 : cmp #<(0) : lda tmp0+1 : sbc #>(0) : bvc *+4 : eor #$80 : bmi *+5 : jmp JBLmain383 : :
	lda #0 : ldx _A2destY : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A2Y : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	sec : lda tmp0 : sbc tmp1 : sta tmp0 : lda tmp0+1 : sbc tmp1+1 : sta tmp0+1 :
	lda #0 : sec : sbc tmp0 : sta reg6 : lda #0 : sbc tmp0+1 : sta reg6+1 :
	jmp JBLmain384 :
JBLmain383
	lda #0 : ldx _A2destY : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A2Y : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	sec : lda tmp0 : sbc tmp1 : sta reg6 : lda tmp0+1 : sbc tmp1+1 : sta reg6+1 :
JBLmain384
	lda #0 : sec : sbc reg6 : sta tmp0 : lda #0 : sbc reg6+1 : sta tmp0+1 :
	lda tmp0 : sta _A2dY :
	lda #0 : ldx _A2dX : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A2dY : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	clc : lda tmp0 : adc tmp1 : sta tmp0 : lda tmp0+1 : adc tmp1+1 : sta tmp0+1 :
	lda tmp0 : sta _A2err :
	lda #0 : ldx _A2X : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A2destX : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda tmp0 : cmp tmp1 : lda tmp0+1 : sbc tmp1+1 : bvc *+4 : eor #$80 : bmi *+5 : jmp JBLmain385 : :
	lda #<(1) : sta reg6 : lda #>(1) : sta reg6+1 :
	jmp JBLmain386 :
JBLmain385
	lda #<(-1) : sta reg6 : lda #>(-1) : sta reg6+1 :
JBLmain386
	lda reg6 : sta _A2sX :
	lda #0 : ldx _A2Y : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A2destY : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda tmp0 : cmp tmp1 : lda tmp0+1 : sbc tmp1+1 : bvc *+4 : eor #$80 : bmi *+5 : jmp JBLmain387 : :
	lda #<(1) : sta reg6 : lda #>(1) : sta reg6+1 :
	jmp JBLmain388 :
JBLmain387
	lda #<(-1) : sta reg6 : lda #>(-1) : sta reg6+1 :
JBLmain388
	lda reg6 : sta _A2sY :
	lda #0 : ldx _A2X : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A2destX : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda tmp0 : eor tmp1 : sta tmp : lda tmp0+1 : eor tmp1+1 : ora tmp : beq *+5 : jmp JBLmain389 :
	lda #0 : ldx _A2Y : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A2destY : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda tmp0 : eor tmp1 : sta tmp : lda tmp0+1 : eor tmp1+1 : ora tmp : beq *+5 : jmp JBLmain389 :
	lda #<(1) : sta reg6 : lda #>(1) : sta reg6+1 :
	jmp JBLmain390 :
JBLmain389
	lda #<(0) : sta reg6 : lda #>(0) : sta reg6+1 :
JBLmain390
	lda reg6 : sta _A2arrived :
	lda #0 : ldx _A1X : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : ldy #0 : sta (sp),y : iny : lda tmp0+1 : sta (sp),y :
	lda #0 : ldx _A2X : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : ldy #2 : sta (sp),y : iny : lda tmp0+1 : sta (sp),y :
	lda #0 : ldx _A1Y : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : ldy #4 : sta (sp),y : iny : lda tmp0+1 : sta (sp),y :
	lda reg0 : sta tmp0 : lda #0 : sta tmp0+1 :
	lda tmp0 : ldy #6 : sta (sp),y : iny : lda tmp0+1 : sta (sp),y :
	lda #0 : ldx reg1 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : ldy #8 : sta (sp),y : iny : lda tmp0+1 : sta (sp),y :
	ldy #10 : jsr _hfill8 :
	jmp JBLmain392 :
JBLmain391
	ldy #0 : jsr _A1stepY :
	ldy #0 : jsr _A2stepY :
	lda #0 : ldx _A1X : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : ldy #0 : sta (sp),y : iny : lda tmp0+1 : sta (sp),y :
	lda #0 : ldx _A2X : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : ldy #2 : sta (sp),y : iny : lda tmp0+1 : sta (sp),y :
	lda #0 : ldx _A1Y : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : ldy #4 : sta (sp),y : iny : lda tmp0+1 : sta (sp),y :
	lda reg0 : sta tmp0 : lda #0 : sta tmp0+1 :
	lda tmp0 : ldy #6 : sta (sp),y : iny : lda tmp0+1 : sta (sp),y :
	lda #0 : ldx reg1 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : ldy #8 : sta (sp),y : iny : lda tmp0+1 : sta (sp),y :
	ldy #10 : jsr _hfill8 :
JBLmain392
	lda #0 : ldx _A1arrived : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : ora tmp0+1 : bne *+5 : jmp JBLmain391 :
	ldy #7 : lda (fp),y : sta _A1X :
	lda reg3 : sta _A1Y :
	lda reg4 : sta _A1destX :
	lda reg5 : sta _A1destY :
	lda #0 : ldx _A1destX : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A1X : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	sec : lda tmp0 : sbc tmp1 : sta tmp0 : lda tmp0+1 : sbc tmp1+1 : sta tmp0+1 :
	lda tmp0 : cmp #<(0) : lda tmp0+1 : sbc #>(0) : bvc *+4 : eor #$80 : bmi *+5 : jmp JBLmain395 : :
	lda #0 : ldx _A1destX : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A1X : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	sec : lda tmp0 : sbc tmp1 : sta tmp0 : lda tmp0+1 : sbc tmp1+1 : sta tmp0+1 :
	lda #0 : sec : sbc tmp0 : sta reg7 : lda #0 : sbc tmp0+1 : sta reg7+1 :
	jmp JBLmain396 :
JBLmain395
	lda #0 : ldx _A1destX : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A1X : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	sec : lda tmp0 : sbc tmp1 : sta reg7 : lda tmp0+1 : sbc tmp1+1 : sta reg7+1 :
JBLmain396
	lda reg7 : sta _A1dX :
	lda #0 : ldx _A1destY : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A1Y : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	sec : lda tmp0 : sbc tmp1 : sta tmp0 : lda tmp0+1 : sbc tmp1+1 : sta tmp0+1 :
	lda tmp0 : cmp #<(0) : lda tmp0+1 : sbc #>(0) : bvc *+4 : eor #$80 : bmi *+5 : jmp JBLmain397 : :
	lda #0 : ldx _A1destY : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A1Y : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	sec : lda tmp0 : sbc tmp1 : sta tmp0 : lda tmp0+1 : sbc tmp1+1 : sta tmp0+1 :
	lda #0 : sec : sbc tmp0 : sta reg7 : lda #0 : sbc tmp0+1 : sta reg7+1 :
	jmp JBLmain398 :
JBLmain397
	lda #0 : ldx _A1destY : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A1Y : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	sec : lda tmp0 : sbc tmp1 : sta reg7 : lda tmp0+1 : sbc tmp1+1 : sta reg7+1 :
JBLmain398
	lda #0 : sec : sbc reg7 : sta tmp0 : lda #0 : sbc reg7+1 : sta tmp0+1 :
	lda tmp0 : sta _A1dY :
	lda #0 : ldx _A1dX : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A1dY : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	clc : lda tmp0 : adc tmp1 : sta tmp0 : lda tmp0+1 : adc tmp1+1 : sta tmp0+1 :
	lda tmp0 : sta _A1err :
	lda #0 : ldx _A1X : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A1destX : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda tmp0 : cmp tmp1 : lda tmp0+1 : sbc tmp1+1 : bvc *+4 : eor #$80 : bmi *+5 : jmp JBLmain399 : :
	lda #<(1) : sta reg7 : lda #>(1) : sta reg7+1 :
	jmp JBLmain400 :
JBLmain399
	lda #<(-1) : sta reg7 : lda #>(-1) : sta reg7+1 :
JBLmain400
	lda reg7 : sta _A1sX :
	lda #0 : ldx _A1Y : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A1destY : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda tmp0 : cmp tmp1 : lda tmp0+1 : sbc tmp1+1 : bvc *+4 : eor #$80 : bmi *+5 : jmp JBLmain401 : :
	lda #<(1) : sta reg7 : lda #>(1) : sta reg7+1 :
	jmp JBLmain402 :
JBLmain401
	lda #<(-1) : sta reg7 : lda #>(-1) : sta reg7+1 :
JBLmain402
	lda reg7 : sta _A1sY :
	lda #0 : ldx _A1X : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A1destX : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda tmp0 : eor tmp1 : sta tmp : lda tmp0+1 : eor tmp1+1 : ora tmp : beq *+5 : jmp JBLmain403 :
	lda #0 : ldx _A1Y : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A1destY : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda tmp0 : eor tmp1 : sta tmp : lda tmp0+1 : eor tmp1+1 : ora tmp : beq *+5 : jmp JBLmain403 :
	lda #<(1) : sta reg7 : lda #>(1) : sta reg7+1 :
	jmp JBLmain404 :
JBLmain403
	lda #<(0) : sta reg7 : lda #>(0) : sta reg7+1 :
JBLmain404
	lda reg7 : sta _A1arrived :
	jmp JBLmain406 :
JBLmain405
	ldy #0 : jsr _A1stepY :
	ldy #0 : jsr _A2stepY :
	lda #0 : ldx _A1X : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : ldy #0 : sta (sp),y : iny : lda tmp0+1 : sta (sp),y :
	lda #0 : ldx _A2X : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : ldy #2 : sta (sp),y : iny : lda tmp0+1 : sta (sp),y :
	lda #0 : ldx _A1Y : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : ldy #4 : sta (sp),y : iny : lda tmp0+1 : sta (sp),y :
	lda reg0 : sta tmp0 : lda #0 : sta tmp0+1 :
	lda tmp0 : ldy #6 : sta (sp),y : iny : lda tmp0+1 : sta (sp),y :
	lda #0 : ldx reg1 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : ldy #8 : sta (sp),y : iny : lda tmp0+1 : sta (sp),y :
	ldy #10 : jsr _hfill8 :
JBLmain406
	lda #0 : ldx _A1arrived : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : ora tmp0+1 : beq *+5 : jmp JBLmain408 :
	lda #0 : ldx _A2arrived : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : ora tmp0+1 : bne *+5 : jmp JBLmain405 :
JBLmain408
	jmp JBLmain369 :
JBLmain368
	ldy #6 : lda (fp),y : sta _A1X :
	lda reg2 : sta _A1Y :
	lda reg4 : sta _A1destX :
	lda reg5 : sta _A1destY :
	lda #0 : ldx _A1destX : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A1X : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	sec : lda tmp0 : sbc tmp1 : sta tmp0 : lda tmp0+1 : sbc tmp1+1 : sta tmp0+1 :
	lda tmp0 : cmp #<(0) : lda tmp0+1 : sbc #>(0) : bvc *+4 : eor #$80 : bmi *+5 : jmp JBLmain410 : :
	lda #0 : ldx _A1destX : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A1X : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	sec : lda tmp0 : sbc tmp1 : sta tmp0 : lda tmp0+1 : sbc tmp1+1 : sta tmp0+1 :
	ldy #8 : lda #0 : sec : sbc tmp0 : sta (fp),y : iny : lda #0 : sbc tmp0+1 : sta (fp),y :
	jmp JBLmain411 :
JBLmain410
	lda #0 : ldx _A1destX : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A1X : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	sec : lda tmp0 : sbc tmp1 : ldy #8 : sta (fp),y : iny : lda tmp0+1 : sbc tmp1+1 : sta (fp),y :
JBLmain411
	ldy #8 : lda (fp),y : sta _A1dX :
	lda #0 : ldx _A1destY : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A1Y : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	sec : lda tmp0 : sbc tmp1 : sta tmp0 : lda tmp0+1 : sbc tmp1+1 : sta tmp0+1 :
	lda tmp0 : cmp #<(0) : lda tmp0+1 : sbc #>(0) : bvc *+4 : eor #$80 : bmi *+5 : jmp JBLmain412 : :
	lda #0 : ldx _A1destY : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A1Y : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	sec : lda tmp0 : sbc tmp1 : sta tmp0 : lda tmp0+1 : sbc tmp1+1 : sta tmp0+1 :
	ldy #8 : lda #0 : sec : sbc tmp0 : sta (fp),y : iny : lda #0 : sbc tmp0+1 : sta (fp),y :
	jmp JBLmain413 :
JBLmain412
	lda #0 : ldx _A1destY : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A1Y : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	sec : lda tmp0 : sbc tmp1 : ldy #8 : sta (fp),y : iny : lda tmp0+1 : sbc tmp1+1 : sta (fp),y :
JBLmain413
	ldy #8 : lda #0 : sec : sbc (fp),y : sta tmp0 : iny : lda #0 : sbc (fp),y : sta tmp0+1 :
	lda tmp0 : sta _A1dY :
	lda #0 : ldx _A1dX : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A1dY : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	clc : lda tmp0 : adc tmp1 : sta tmp0 : lda tmp0+1 : adc tmp1+1 : sta tmp0+1 :
	lda tmp0 : sta _A1err :
	lda #0 : ldx _A1X : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A1destX : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda tmp0 : cmp tmp1 : lda tmp0+1 : sbc tmp1+1 : bvc *+4 : eor #$80 : bmi *+5 : jmp JBLmain414 : :
	ldy #8 : lda #<(1) : sta (fp),y : iny : lda #>(1) : sta (fp),y :
	jmp JBLmain415 :
JBLmain414
	ldy #8 : lda #<(-1) : sta (fp),y : iny : lda #>(-1) : sta (fp),y :
JBLmain415
	ldy #8 : lda (fp),y : sta _A1sX :
	lda #0 : ldx _A1Y : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A1destY : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda tmp0 : cmp tmp1 : lda tmp0+1 : sbc tmp1+1 : bvc *+4 : eor #$80 : bmi *+5 : jmp JBLmain416 : :
	ldy #8 : lda #<(1) : sta (fp),y : iny : lda #>(1) : sta (fp),y :
	jmp JBLmain417 :
JBLmain416
	ldy #8 : lda #<(-1) : sta (fp),y : iny : lda #>(-1) : sta (fp),y :
JBLmain417
	ldy #8 : lda (fp),y : sta _A1sY :
	lda #0 : ldx _A1X : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A1destX : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda tmp0 : eor tmp1 : sta tmp : lda tmp0+1 : eor tmp1+1 : ora tmp : beq *+5 : jmp JBLmain418 :
	lda #0 : ldx _A1Y : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A1destY : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda tmp0 : eor tmp1 : sta tmp : lda tmp0+1 : eor tmp1+1 : ora tmp : beq *+5 : jmp JBLmain418 :
	ldy #8 : lda #<(1) : sta (fp),y : iny : lda #>(1) : sta (fp),y :
	jmp JBLmain419 :
JBLmain418
	ldy #8 : lda #<(0) : sta (fp),y : iny : lda #>(0) : sta (fp),y :
JBLmain419
	ldy #8 : lda (fp),y : sta _A1arrived :
	ldy #7 : lda (fp),y : sta _A2X :
	lda reg3 : sta _A2Y :
	lda reg4 : sta _A2destX :
	lda reg5 : sta _A2destY :
	lda #0 : ldx _A2destX : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A2X : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	sec : lda tmp0 : sbc tmp1 : sta tmp0 : lda tmp0+1 : sbc tmp1+1 : sta tmp0+1 :
	lda tmp0 : cmp #<(0) : lda tmp0+1 : sbc #>(0) : bvc *+4 : eor #$80 : bmi *+5 : jmp JBLmain420 : :
	lda #0 : ldx _A2destX : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A2X : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	sec : lda tmp0 : sbc tmp1 : sta tmp0 : lda tmp0+1 : sbc tmp1+1 : sta tmp0+1 :
	ldy #8 : lda #0 : sec : sbc tmp0 : sta (fp),y : iny : lda #0 : sbc tmp0+1 : sta (fp),y :
	jmp JBLmain421 :
JBLmain420
	lda #0 : ldx _A2destX : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A2X : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	sec : lda tmp0 : sbc tmp1 : ldy #8 : sta (fp),y : iny : lda tmp0+1 : sbc tmp1+1 : sta (fp),y :
JBLmain421
	ldy #8 : lda (fp),y : sta _A2dX :
	lda #0 : ldx _A2destY : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A2Y : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	sec : lda tmp0 : sbc tmp1 : sta tmp0 : lda tmp0+1 : sbc tmp1+1 : sta tmp0+1 :
	lda tmp0 : cmp #<(0) : lda tmp0+1 : sbc #>(0) : bvc *+4 : eor #$80 : bmi *+5 : jmp JBLmain422 : :
	lda #0 : ldx _A2destY : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A2Y : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	sec : lda tmp0 : sbc tmp1 : sta tmp0 : lda tmp0+1 : sbc tmp1+1 : sta tmp0+1 :
	ldy #8 : lda #0 : sec : sbc tmp0 : sta (fp),y : iny : lda #0 : sbc tmp0+1 : sta (fp),y :
	jmp JBLmain423 :
JBLmain422
	lda #0 : ldx _A2destY : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A2Y : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	sec : lda tmp0 : sbc tmp1 : ldy #8 : sta (fp),y : iny : lda tmp0+1 : sbc tmp1+1 : sta (fp),y :
JBLmain423
	ldy #8 : lda #0 : sec : sbc (fp),y : sta tmp0 : iny : lda #0 : sbc (fp),y : sta tmp0+1 :
	lda tmp0 : sta _A2dY :
	lda #0 : ldx _A2dX : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A2dY : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	clc : lda tmp0 : adc tmp1 : sta tmp0 : lda tmp0+1 : adc tmp1+1 : sta tmp0+1 :
	lda tmp0 : sta _A2err :
	lda #0 : ldx _A2X : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A2destX : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda tmp0 : cmp tmp1 : lda tmp0+1 : sbc tmp1+1 : bvc *+4 : eor #$80 : bmi *+5 : jmp JBLmain424 : :
	ldy #8 : lda #<(1) : sta (fp),y : iny : lda #>(1) : sta (fp),y :
	jmp JBLmain425 :
JBLmain424
	ldy #8 : lda #<(-1) : sta (fp),y : iny : lda #>(-1) : sta (fp),y :
JBLmain425
	ldy #8 : lda (fp),y : sta _A2sX :
	lda #0 : ldx _A2Y : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A2destY : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda tmp0 : cmp tmp1 : lda tmp0+1 : sbc tmp1+1 : bvc *+4 : eor #$80 : bmi *+5 : jmp JBLmain426 : :
	ldy #8 : lda #<(1) : sta (fp),y : iny : lda #>(1) : sta (fp),y :
	jmp JBLmain427 :
JBLmain426
	ldy #8 : lda #<(-1) : sta (fp),y : iny : lda #>(-1) : sta (fp),y :
JBLmain427
	ldy #8 : lda (fp),y : sta _A2sY :
	lda #0 : ldx _A2X : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A2destX : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda tmp0 : eor tmp1 : sta tmp : lda tmp0+1 : eor tmp1+1 : ora tmp : beq *+5 : jmp JBLmain428 :
	lda #0 : ldx _A2Y : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #0 : ldx _A2destY : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda tmp0 : eor tmp1 : sta tmp : lda tmp0+1 : eor tmp1+1 : ora tmp : beq *+5 : jmp JBLmain428 :
	ldy #8 : lda #<(1) : sta (fp),y : iny : lda #>(1) : sta (fp),y :
	jmp JBLmain429 :
JBLmain428
	ldy #8 : lda #<(0) : sta (fp),y : iny : lda #>(0) : sta (fp),y :
JBLmain429
	ldy #8 : lda (fp),y : sta _A2arrived :
	lda #0 : ldx _A1X : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : ldy #0 : sta (sp),y : iny : lda tmp0+1 : sta (sp),y :
	lda #0 : ldx _A2X : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : ldy #2 : sta (sp),y : iny : lda tmp0+1 : sta (sp),y :
	lda #0 : ldx _A1Y : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : ldy #4 : sta (sp),y : iny : lda tmp0+1 : sta (sp),y :
	lda reg0 : sta tmp0 : lda #0 : sta tmp0+1 :
	lda tmp0 : ldy #6 : sta (sp),y : iny : lda tmp0+1 : sta (sp),y :
	lda #0 : ldx reg1 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : ldy #8 : sta (sp),y : iny : lda tmp0+1 : sta (sp),y :
	ldy #10 : jsr _hfill8 :
	jmp JBLmain431 :
JBLmain430
	ldy #0 : jsr _A1stepY :
	ldy #0 : jsr _A2stepY :
	lda #0 : ldx _A1X : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : ldy #0 : sta (sp),y : iny : lda tmp0+1 : sta (sp),y :
	lda #0 : ldx _A2X : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : ldy #2 : sta (sp),y : iny : lda tmp0+1 : sta (sp),y :
	lda #0 : ldx _A1Y : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : ldy #4 : sta (sp),y : iny : lda tmp0+1 : sta (sp),y :
	lda reg0 : sta tmp0 : lda #0 : sta tmp0+1 :
	lda tmp0 : ldy #6 : sta (sp),y : iny : lda tmp0+1 : sta (sp),y :
	lda #0 : ldx reg1 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : ldy #8 : sta (sp),y : iny : lda tmp0+1 : sta (sp),y :
	ldy #10 : jsr _hfill8 :
JBLmain431
	lda #0 : ldx _A1arrived : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : ora tmp0+1 : beq *+5 : jmp JBLmain433 :
	lda #0 : ldx _A2arrived : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : ora tmp0+1 : bne *+5 : jmp JBLmain430 :
JBLmain433
JBLmain369
.)
	jmp leave :
*/