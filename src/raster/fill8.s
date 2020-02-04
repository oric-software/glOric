


_A1X .byt 0
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
_A2destY .byt 0
_A2dX .byt 0
_A2dY .byt 0
_A2err .byt 0
_A2sX .byt 0
_A2sY .byt 0
_A2arrived .byt 0



_P1X .byt 0
_P1Y .byt 0
_P2X .byt 0
_P2Y .byt 0
_P3X .byt 0
_P3Y .byt 0

_P1AH .byt 0
_P1AV .byt 0
_P2AH .byt 0
_P2AV .byt 0
_P3AH .byt 0
_P3AV .byt 0


_pDepX  .byt 0
_pDepY  .byt 0
_pArr1X .byt 0
_pArr1Y .byt 0
_pArr2X .byt 0
_pArr2Y .byt 0

_distface .byt 0
_distseg .byt 0
_ch2disp .byt 0

/*
void A1stepY(){
	signed char  nxtY, e2;
	nxtY = A1Y+A1sY;
	printf ("nxtY = %d\n", nxtY);
	e2 = (A1err < 0) ? (
			((A1err & 0x40) == 0)?(
				0x80
			):(
				A1err << 1
			)
		):(
			((A1err & 0x40) != 0)?(
				0x7F
			):(
				A1err << 1
			)
		);
	printf ("e2 = %d\n", e2);
	while ((A1arrived == 0) && ((e2>A1dX) || (A1Y!=nxtY))){
		if (e2 >= A1dY){
			A1err += A1dY;
			printf ("A1err = %d\n", A1err);
			A1X += A1sX;
			printf ("A1X = %d\n", A1X);
		}
		if (e2 <= A1dX){
			A1err += A1dX;
			printf ("A1err = %d\n", A1err);
			A1Y += A1sY;
			printf ("A1Y = %d\n", A1Y);
		}
		A1arrived=((A1X == A1destX) && ( A1Y == A1destY))?1:0;
		e2 = (A1err < 0) ? (
				((A1err & 0x40) == 0)?(
					0x80
				):(
					A1err << 1
				)
			):(
				((A1err & 0x40) != 0)?(
					0x7F
				):(
					A1err << 1
				)
			);
		printf ("e2 = %d\n", e2);

		}
}
*/

#ifdef USE_ASM_BRESFILL
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
	bpl A1stepY_errpositiv_01
	asl
	bmi A1stepY_errdone_01
	lda #$80
	jmp A1stepY_errdone_01
	
A1stepY_errpositiv_01:	
	asl
	bpl A1stepY_errdone_01
	lda #$7F
A1stepY_errdone_01:	
	sta reg0
	
	;; while ((A1arrived == 0) && ((e2>A1dX) || (A1Y!=nxtY))){
A1stepY_loop:
	lda _A1arrived ;; (A1arrived == 0)
	beq A1stepY_notarrived
	jmp A1stepYdone

A1stepY_notarrived:	
	lda _A1dX 		;; (e2>A1dX)
    sec
	sbc reg0
    bvc *+4
    eor #$80
	bmi A1stepY_doloop

	lda reg1 		;; (A1Y!=nxtY)
	cmp _A1Y
	bne A1stepY_doloop
	
	jmp A1stepYdone
A1stepY_doloop:
	
		;; if (e2 >= A1dY){
		lda reg0 ; e2
        sec
        sbc _A1dY
        bvc *+4
        eor #$80
		bmi A1stepY_A1Xdone
		;; 	A1err += A1dY;
			clc
			lda _A1err
			adc _A1dY
			bvc debug_moi_la
erroverflow:
			jmp A1stepYdone
debug_moi_la:
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
        sec
		sbc reg0
        bvc *+4
        eor #$80
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
		bpl A1stepY_errpositiv_02
		asl
		bmi A1stepY_errdone_02
		lda #$80
		jmp A1stepY_errdone_02
		
A1stepY_errpositiv_02:	
		asl
		bpl A1stepY_errdone_02
		lda #$7F
A1stepY_errdone_02:	
		sta reg0
	
	jmp A1stepY_loop
A1stepYdone:	

	// restore context
	pla: sta reg1: pla: sta reg0
	pla

.)
	rts
#endif


/*
void A2stepY(){
	signed char  nxtY, e2;
	nxtY = A2Y+A2sY	;
	e2 = (A2err < 0) ? (
			((A2err & 0x40) == 0)?(
				0x80
			):(
				A2err << 1
			)
		):(
			((A2err & 0x40) != 0)?(
				0x7F
			):(
				A2err << 1
			)
		);
	while ((A2arrived == 0) && ((e2>A2dX) || (A2Y!=nxtY))){
		if (e2 >= A2dY){
			A2err += A2dY;
			A2X += A2sX;
		}
		if (e2 <= A2dX){
			A2err += A2dX;
			A2Y += A2sY;
		}
		A2arrived=((A2X == A2destX) && ( A2Y == A2destY))?1:0;
		e2 = (A2err < 0) ? (
				((A2err & 0x40) == 0)?(
					0x80
				):(
					A2err << 1
				)
			):(
				((A2err & 0x40) != 0)?(
					0x7F
				):(
					A2err << 1
				)
			);
	}
}
*/
	
#ifdef USE_ASM_BRESFILL
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
	bpl A2stepY_errpositiv_01
	asl
	bmi A2stepY_errdone_01
	lda #$80
	jmp A2stepY_errdone_01
	
A2stepY_errpositiv_01:	
	asl
	bpl A2stepY_errdone_01
	lda #$7F
A2stepY_errdone_01:	
	sta reg0
	
	;; while ((A2arrived == 0) && ((e2>A2dX) || (A2Y!=nxtY))){
A2stepY_loop:
	lda _A2arrived ;; (A2arrived == 0)
	beq A2stepY_notarrived
	jmp A2stepYdone

A2stepY_notarrived:	
	lda _A2dX 		;; (e2>A2dX)
    sec
    sbc reg0
    bvc *+4
    eor #$80
	bmi A2stepY_doloop

	lda reg1 		;; (A2Y!=nxtY)
	cmp _A2Y
	bne A2stepY_doloop
	
	jmp A2stepYdone
A2stepY_doloop:
	
		;; if (e2 >= A2dY){
		lda reg0 ; e2
        sec
        sbc _A2dY
        bvc *+4
        eor #$80
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
        sec
        sbc reg0
        bvc *+4
        eor #$80
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
		bpl A2stepY_errpositiv_02
		asl
		bmi A2stepY_errdone_02
		lda #$80
		jmp A2stepY_errdone_02
		
A2stepY_errpositiv_02:	
		asl
		bpl A2stepY_errdone_02
		lda #$7F
A2stepY_errdone_02:	
		sta reg0
	
	jmp A2stepY_loop
A2stepYdone:	

	// restore context
	pla: sta reg1: pla: sta reg0
	pla

.)
	rts
#endif 

#ifdef USE_ASM_BRESFILL

// void hfill8(signed char   p1x,
//             signed char   p2x,
//             signed char   py,
//             unsigned char dist,
//             char          char2disp);

_hfill82:
.(
; sp+0 => p1x coordinate
; sp+2 => p2x coordinate
; sp+4 => py
; sp+6 => dist
; sp+8 => char2disp
ldx #7 : lda #7 : jsr enter :
	// save context
    pha:txa:pha:tya:pha
	lda reg0: pha ;; p1x 
    lda reg1: pha ;; p2x
	lda reg2: pha ;; pY
    lda reg3: pha ;; dist
    lda reg4: pha ;; char2disp
	lda tmp0: pha ;; dx
	lda tmp1: pha ;; fx
	lda tmp2: pha ;; nbpoints
	lda tmp3: pha: lda tmp3+1: pha  ;; save stack pointer

//     if ((py <= 0) || (py >= SCREEN_HEIGHT)) return;
	ldy #4
	lda (sp),y				; Access Y coordinate
    bpl *+5
    jmp hfill8_done
    cmp #SCREEN_HEIGHT
    bcc *+5
	jmp hfill8_done
    sta reg2
    tax

	ldy #2
	lda (sp), y				; get p2x 
	sta reg1

//     if (p1x > p2x) {
	ldy #0
	lda (sp), y				; get p1x 
	sta reg0
	sec
	sbc reg1				; signed cmp to p2x
	bvc *+4
	eor #$80
	bmi hfill8_p2xOverOrEqualp1x
//         dx = max(0, p2x);
		lda reg1
		bpl hfill8_p2xPositiv
		lda #0
hfill8_p2xPositiv:
		sta tmp0
//         fx = min(p1x, SCREEN_WIDTH - 1);
		lda reg0 ; p1x
		sta tmp1
		sec
		sbc #SCREEN_WIDTH - 1
		bvc *+4
		eor #$80
		bmi hfill8_p1xOverScreenWidth
		lda #SCREEN_WIDTH - 1
		sta tmp1
hfill8_p1xOverScreenWidth:
		jmp hfill8_computeNbPoints
hfill8_p2xOverOrEqualp1x:
//     } else {
//         dx = max(0, p1x);
		lda reg0 ; p1x
		bpl hfill8_p1xPositiv
		lda #0
hfill8_p1xPositiv:
		sta tmp0
//         fx = min(p2x, SCREEN_WIDTH - 1);
		lda reg1 ; p2x
		sta tmp1
		sec
		sbc #SCREEN_WIDTH - 1
		bvc *+4
		eor $80
		bmi hfill8_p2xOverScreenWidth
		lda #SCREEN_WIDTH - 1
		sta tmp1
hfill8_p2xOverScreenWidth:
//     }
hfill8_computeNbPoints:
//     nbpoints = fx - dx;
	sec
	lda tmp1
	sbc tmp0
	bmi hfill8_done
//     if (nbpoints < 0) return;

//     // printf ("dx=%d py=%d nbpoints=%d dist= %d, char2disp= %d\n", dx, py, nbpoints,  dist, char2disp);get();

// #ifdef USE_ZBUFFER
//     zline(dx, py, nbpoints, dist, char2disp);
	clc
	lda sp
	adc #10
	sta sp
	lda sp+1
	adc #0
	sta sp+1
	lda tmp0 : ldy #0 : sta (sp),y ;; dx
	lda reg2 : ldy #2 : sta (sp),y ;; py
	lda tmp2 : ldy #4 : sta (sp),y ;; nbpoints
	lda reg3 : ldy #6 : sta (sp),y ;; dist
	lda reg4 : ldy #8 : sta (sp),y ;; char2disp
	ldy #10 : jsr _zline
// #else
//     // TODO : draw a line whit no z-buffer
// #endif

hfill8_done:
	// restore context
	pla: sta tmp3+1
	pla: sta tmp3
	pla: sta tmp2
	pla: sta tmp1
	pla: sta tmp0
    pla: sta reg4
	pla: sta reg3
    pla: sta reg2
	pla: sta reg1
    pla: sta reg0
	pla:tay:pla:tax:pla
// }

.)
	jmp leave :
	;;    rts



_hfill8
	ldx #7 : lda #7 : jsr enter :
	ldy #0 : lda (ap),y : sta tmp0 : iny : lda (ap),y : sta tmp0+1 :
	lda tmp0 : sta reg0 :
	ldy #2 : lda (ap),y : sta tmp0 : iny : lda (ap),y : sta tmp0+1 :
	lda tmp0 : sta reg1 :
	ldy #4 : lda (ap),y : sta tmp0 : iny : lda (ap),y : sta tmp0+1 :
	lda tmp0 : sta reg2 :
	ldy #6 : lda (ap),y : sta tmp0 : iny : lda (ap),y : sta tmp0+1 :
	ldy #6 : lda tmp0 : sta (ap),y :
	ldy #8 : lda (ap),y : sta tmp0 : iny : lda (ap),y : sta tmp0+1 :
	ldy #8 : lda tmp0 : sta (ap),y :
	lda reg2 : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #<(0) : cmp tmp0 : lda #>(0) : sbc tmp0+1 : bvc *+4 : eor #$80 : bmi *+5 : jmp Lbresfill223 : : :
	lda tmp0 : cmp #<(26) : lda tmp0+1 : sbc #>(26) : .( : bvc *+4 : eor #$80 : bpl skip : jmp Lbresfill221 :skip : .) : :
Lbresfill223
	jmp leave :
Lbresfill221
	lda reg0 : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda reg1 : sta tmp1 :
	lda #0 : ldx tmp1 : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda tmp1 : cmp tmp0 : lda tmp1+1 : sbc tmp0+1 : bvc *+4 : eor #$80 : bmi *+5 : jmp Lbresfill224 : : :
	lda reg1 : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : cmp #<(0) : lda tmp0+1 : sbc #>(0) : bvc *+4 : eor #$80 : bmi *+5 : jmp Lbresfill227 : : :
	lda #<(0) : sta reg5 : lda #>(0) : sta reg5+1 :
	jmp Lbresfill228 :
Lbresfill227
	lda reg1 : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : sta reg5 : lda tmp0+1 : sta reg5+1 :
Lbresfill228
	lda reg5 : sta tmp0 : lda reg5+1 : sta tmp0+1 :
	lda tmp0 : sta reg3 :
	lda reg0 : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : cmp #<(39) : lda tmp0+1 : sbc #>(39) : bvc *+4 : eor #$80 : bmi *+5 : jmp Lbresfill229 : :
	lda reg0 : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : sta reg5 : lda tmp0+1 : sta reg5+1 :
	jmp Lbresfill230 :
Lbresfill229
	lda #<(39) : sta reg5 : lda #>(39) : sta reg5+1 :
Lbresfill230
	lda reg5 : sta tmp0 : lda reg5+1 : sta tmp0+1 :
	ldy #6 : lda tmp0 : sta (fp),y :
	jmp Lbresfill225 :
Lbresfill224
	lda reg0 : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : cmp #<(0) : lda tmp0+1 : sbc #>(0) : bvc *+4 : eor #$80 : bmi *+5 : jmp Lbresfill232 : : :
	lda #<(0) : sta reg6 : lda #>(0) : sta reg6+1 :
	jmp Lbresfill233 :
Lbresfill232
	lda reg0 : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : sta reg6 : lda tmp0+1 : sta reg6+1 :
Lbresfill233
	lda reg6 : sta tmp0 : lda reg6+1 : sta tmp0+1 :
	lda tmp0 : sta reg3 :
	lda reg1 : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : cmp #<(39) : lda tmp0+1 : sbc #>(39) : bvc *+4 : eor #$80 : bmi *+5 : jmp Lbresfill234 : :
	lda reg1 : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : sta reg6 : lda tmp0+1 : sta reg6+1 :
	jmp Lbresfill235 :
Lbresfill234
	lda #<(39) : sta reg6 : lda #>(39) : sta reg6+1 :
Lbresfill235
	lda reg6 : sta tmp0 : lda reg6+1 : sta tmp0+1 :
	ldy #6 : lda tmp0 : sta (fp),y :
Lbresfill225
	ldy #6 : lda (fp),y : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda reg3 : sta tmp1 :
	lda #0 : ldx tmp1 : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	sec : lda tmp0 : sbc tmp1 : sta tmp0 : lda tmp0+1 : sbc tmp1+1 : sta tmp0+1 :
	lda tmp0 : sta reg4 :
	lda reg4 : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : cmp #<(0) : lda tmp0+1 : sbc #>(0) : bvc *+4 : eor #$80 : bmi *+5 : jmp Lbresfill236 : :
	jmp leave :
Lbresfill236
	lda reg3 : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : ldy #0 : sta (sp),y : iny : lda tmp0+1 : sta (sp),y :
	lda reg2 : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : ldy #2 : sta (sp),y : iny : lda tmp0+1 : sta (sp),y :
	lda reg4 : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : sta tmp0 : lda #0 : sta tmp0+1 :
	lda tmp0 : ldy #4 : sta (sp),y : iny : lda tmp0+1 : sta (sp),y :
	ldy #6 : lda (ap),y : sta tmp0 :
	lda tmp0 : sta tmp0 : lda #0 : sta tmp0+1 :
	lda tmp0 : ldy #6 : sta (sp),y : iny : lda tmp0+1 : sta (sp),y :
	ldy #8 : lda (ap),y : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : ldy #8 : sta (sp),y : iny : lda tmp0+1 : sta (sp),y :
	ldy #10 : jsr _zline :
	jmp leave :

#endif