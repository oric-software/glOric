#include "config.h"
#ifdef USE_PROFILER
#include "profile.h"
#endif 


#define OPCODE_DEC_ZERO $C6
#define OPCODE_INC_ZERO $E6


.zero

_A1X .dsb 1
_A1Y .dsb 1
_A1destX .dsb 1
_A1destY .dsb 1
_A1dX .dsb 1
_A1dY .dsb 1
_A1err .dsb 1
_A1sX .dsb 1
_A1sY .dsb 1
_A1arrived .dsb 1
_A2X .dsb 1
_A2Y .dsb 1
_A2destX .dsb 1
_A2destY .dsb 1
_A2dX .dsb 1
_A2dY .dsb 1
_A2err .dsb 1
_A2sX .dsb 1
_A2sY .dsb 1
_A2arrived .dsb 1

.text


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
_distpoint .byt 0
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
			bvc A1stepY_debug_moi_la
			jmp A1stepYdone
A1stepY_debug_moi_la:			
			sta _A1err
		;; 	A1X += A1sX;
_patch_A1stepY_incdec_A1X
			inc _A1X 
			; clc
			; lda _A1X
			; adc _A1sX
			; sta _A1X
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
		;; 	A1Y += A1sY; // Optim:  substraction by dec _A1Y
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
patch_A2stepY_incdec_A2X:
			inc _A2X
			; clc
			; lda _A2X
			; adc _A2sX
			; sta _A2X
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
		;; 	A2Y += A2sY; // // Optim:  substraction dec _A2Y
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


	rts
#endif //  USE_ASM_BRESFILL

#ifdef USE_ASM_HFILL


// void hfill() {
_hfill:
.(
; #ifdef USE_PROFILER
; PROFILE_ENTER(ROUTINE_HFILL)
; #endif
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

//     signed char dx, fx;
//     signed char nbpoints;

//     //printf ("p1x=%d p2x=%d py=%d dist= %d, char2disp= %d\n", p1x, p2x, dist,  dist, char2disp);get();

//     if ((A1Y <= 0) || (A1Y >= SCREEN_HEIGHT)) return;
	lda _A1Y				; Access Y coordinate
    bpl *+5
    jmp hfill_done
#ifdef USE_COLOR
    cmp #SCREEN_HEIGHT-NB_LESS_LINES_4_COLOR
#else
    cmp #SCREEN_HEIGHT
#endif
    bcc *+5
	jmp hfill_done
    sta reg2 ; A1Y

//     if (A1X > A2X) {
	lda _A1X				
	sta reg0
	sec
	sbc _A2X				; signed cmp to p2x
	bvc *+4
	eor #$80
	bmi hfill_A2xOverOrEqualA1x
#ifdef USE_COLOR
//		dx = max(2, A2X);
		lda _A2X
		sec
		sbc #COLUMN_OF_COLOR_ATTRIBUTE
		bvc *+4
		eor #$80
		bmi hfill_A2xLowerThan3
		lda _A2X
		jmp hfill_A2xPositiv
hfill_A2xLowerThan3:
		lda #COLUMN_OF_COLOR_ATTRIBUTE
#else
//      dx = max(0, A2X);
		lda _A2X
		bpl hfill_A2xPositiv
		lda #0
#endif
hfill_A2xPositiv:
		sta tmp0 ; dx
//         fx = min(A1X, SCREEN_WIDTH - 1);
		lda _A1X
		sta tmp1
		sec
		sbc #SCREEN_WIDTH - 1
		bvc *+4
		eor #$80
		bmi hfill_A1xOverScreenWidth
		lda #SCREEN_WIDTH - 1
		sta tmp1
hfill_A1xOverScreenWidth:
		jmp hfill_computeNbPoints
hfill_A2xOverOrEqualA1x:
//     } else {
#ifdef USE_COLOR
//		dx = max(2, A1X);
		lda _A1X
		sec
		sbc #COLUMN_OF_COLOR_ATTRIBUTE
		bvc *+4
		eor #$80
		bmi hfill_A1xLowerThan3
		lda _A1X
		jmp hfill_A1xPositiv
hfill_A1xLowerThan3:
		lda #COLUMN_OF_COLOR_ATTRIBUTE
#else
//      dx = max(0, A1X);
		lda _A1X
		bpl hfill_A1xPositiv
		lda #0
#endif
hfill_A1xPositiv:
		sta tmp0
//         fx = min(A2X, SCREEN_WIDTH - 1);
		lda _A2X ; p2x
		sta tmp1
		sec
		sbc #SCREEN_WIDTH - 1
		bvc *+4
		eor $80
		bmi hfill_A2xOverScreenWidth
		lda #SCREEN_WIDTH - 1
		sta tmp1
hfill_A2xOverScreenWidth:
//     }
hfill_computeNbPoints:
//     nbpoints = fx - dx;
//     if (nbpoints < 0) return;
	sec
	lda tmp1
	sbc tmp0
	bmi hfill_done
	sta tmp2

//     // printf ("dx=%d py=%d nbpoints=%d dist= %d, char2disp= %d\n", dx, py, nbpoints,  dist, char2disp);get();

// #ifdef USE_ZBUFFER
//     zline(dx, A1Y, nbpoints, distface, ch2disp);
	clc
	lda sp
	sta tmp3
	adc #10
	sta sp
	lda sp+1
	sta tmp3+1
	adc #0
	sta sp+1
	lda tmp0 : ldy #0 : sta (sp),y ;; dx
	lda reg2 : ldy #2 : sta (sp),y ;; py
	lda tmp2 : ldy #4 : sta (sp),y ;; nbpoints
	lda _distface : ldy #6 : sta (sp),y ;; dist
	lda _ch2disp : ldy #8 : sta (sp),y ;; char2disp
	ldy #10 : jsr _zline
	lda tmp3
	sta sp
	lda tmp3+1
	sta sp+1
// #else
//     // TODO : draw a line whit no z-buffer
// #endif
hfill_done:
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
; #ifdef USE_PROFILER
; PROFILE_LEAVE(ROUTINE_HFILL)
; #endif
.)
	rts

#endif // USE_ASM_HFILL

#ifdef USE_ASM_ANGLE2SCREEN


// void angle2screen() {
_angle2screen:
.(

	// save context
    pha

//     P1X = (SCREEN_WIDTH - P1AH) >> 1;
	sec
	lda #SCREEN_WIDTH
	sbc _P1AH
	cmp #$80
	ror
	sta _P1X
//     P1Y = (SCREEN_HEIGHT - P1AV) >> 1;
	sec
	lda #SCREEN_HEIGHT
	sbc _P1AV
	cmp #$80
	ror
	sta _P1Y
//     P2X = (SCREEN_WIDTH - P2AH) >> 1;
	sec
	lda #SCREEN_WIDTH
	sbc _P2AH
	cmp #$80
	ror
	sta _P2X
//     P2Y = (SCREEN_HEIGHT - P2AV) >> 1;
	sec
	lda #SCREEN_HEIGHT
	sbc _P2AV
	cmp #$80
	ror
	sta _P2Y
//     P3X = (SCREEN_WIDTH - P3AH) >> 1;
	sec
	lda #SCREEN_WIDTH
	sbc _P3AH
	cmp #$80
	ror
	sta _P3X
//     P3Y = (SCREEN_HEIGHT - P3AV) >> 1;
	sec
	lda #SCREEN_HEIGHT
	sbc _P3AV
	cmp #$80
	ror
	sta _P3Y

	// restore context
	pla
// }
.)
	rts

#endif // USE_ASM_ANGLE2SCREEN

#ifdef USE_ASM_BRESFILL

;; void prepare_bresrun() {

    ; if (P1Y <= P2Y) {
    ;     if (P2Y <= P3Y) {
    ;         pDepX  = P3X;
    ;         pDepY  = P3Y;
    ;         pArr1X = P2X;
    ;         pArr1Y = P2Y;
    ;         pArr2X = P1X;
    ;         pArr2Y = P1Y;
    ;     } else {
    ;         pDepX = P2X;
    ;         pDepY = P2Y;
    ;         if (P1Y <= P3Y) {
    ;             pArr1X = P3X;
    ;             pArr1Y = P3Y;
    ;             pArr2X = P1X;
    ;             pArr2Y = P1Y;
    ;         } else {
    ;             pArr1X = P1X;
    ;             pArr1Y = P1Y;
    ;             pArr2X = P3X;
    ;             pArr2Y = P3Y;
    ;         }
    ;     }
    ; } else {
    ;     if (P1Y <= P3Y) {
    ;         pDepX  = P3X;
    ;         pDepY  = P3Y;
    ;         pArr1X = P1X;
    ;         pArr1Y = P1Y;
    ;         pArr2X = P2X;
    ;         pArr2Y = P2Y;
    ;     } else {
    ;         pDepX = P1X;
    ;         pDepY = P1Y;
    ;         if (P2Y <= P3Y) {
    ;             pArr1X = P3X;
    ;             pArr1Y = P3Y;
    ;             pArr2X = P2X;
    ;             pArr2Y = P2Y;
    ;         } else {
    ;             pArr1X = P2X;
    ;             pArr1Y = P2Y;
    ;             pArr2X = P3X;
    ;             pArr2Y = P3Y;
    ;         }
    ;     }
    ; }

;;}

_prepare_bresrun:
.(
; #ifdef USE_PROFILER
; PROFILE_ENTER(ROUTINE_PREPAREBRESRUN)
; #endif
	lda _P1Y : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda _P2Y : sta tmp1 :
	lda #0 : ldx tmp1 : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda tmp1 : cmp tmp0 : lda tmp1+1 : sbc tmp0+1 : .( : bvc *+4 : eor #$80 : bpl skip : jmp prepare_bresrun_Lbresfill129 :skip : .) : : :
	lda _P2Y : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda _P3Y : sta tmp1 :
	lda #0 : ldx tmp1 : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda tmp1 : cmp tmp0 : lda tmp1+1 : sbc tmp0+1 : .( : bvc *+4 : eor #$80 : bpl skip : jmp prepare_bresrun_Lbresfill131 :skip : .) : : :
	lda _P3X : sta _pDepX :
	lda _P3Y : sta _pDepY :
	lda _P2X : sta _pArr1X :
	lda _P2Y : sta _pArr1Y :
	lda _P1X : sta _pArr2X :
	lda _P1Y : sta _pArr2Y :
	jmp prepare_bresrun_Lbresfill130 :
prepare_bresrun_Lbresfill131
	lda _P2X : sta _pDepX :
	lda _P2Y : sta _pDepY :
	lda _P1Y : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda _P3Y : sta tmp1 :
	lda #0 : ldx tmp1 : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda tmp1 : cmp tmp0 : lda tmp1+1 : sbc tmp0+1 : .( : bvc *+4 : eor #$80 : bpl skip : jmp prepare_bresrun_Lbresfill133 :skip : .) : : :
	lda _P3X : sta _pArr1X :
	lda _P3Y : sta _pArr1Y :
	lda _P1X : sta _pArr2X :
	lda _P1Y : sta _pArr2Y :
	jmp prepare_bresrun_Lbresfill130 :
prepare_bresrun_Lbresfill133
	lda _P1X : sta _pArr1X :
	lda _P1Y : sta _pArr1Y :
	lda _P3X : sta _pArr2X :
	lda _P3Y : sta _pArr2Y :
	jmp prepare_bresrun_Lbresfill130 :
prepare_bresrun_Lbresfill129
	lda _P1Y : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda _P3Y : sta tmp1 :
	lda #0 : ldx tmp1 : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda tmp1 : cmp tmp0 : lda tmp1+1 : sbc tmp0+1 : .( : bvc *+4 : eor #$80 : bpl skip : jmp prepare_bresrun_Lbresfill135 :skip : .) : : :
	lda _P3X : sta _pDepX :
	lda _P3Y : sta _pDepY :
	lda _P1X : sta _pArr1X :
	lda _P1Y : sta _pArr1Y :
	lda _P2X : sta _pArr2X :
	lda _P2Y : sta _pArr2Y :
	jmp prepare_bresrun_Lbresfill136 :
prepare_bresrun_Lbresfill135
	lda _P1X : sta _pDepX :
	lda _P1Y : sta _pDepY :
	lda _P2Y : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda _P3Y : sta tmp1 :
	lda #0 : ldx tmp1 : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda tmp1 : cmp tmp0 : lda tmp1+1 : sbc tmp0+1 : .( : bvc *+4 : eor #$80 : bpl skip : jmp prepare_bresrun_Lbresfill137 :skip : .) : : :
	lda _P3X : sta _pArr1X :
	lda _P3Y : sta _pArr1Y :
	lda _P2X : sta _pArr2X :
	lda _P2Y : sta _pArr2Y :
	jmp prepare_bresrun_Lbresfill138 :
prepare_bresrun_Lbresfill137
	lda _P2X : sta _pArr1X :
	lda _P2Y : sta _pArr1Y :
	lda _P3X : sta _pArr2X :
	lda _P3Y : sta _pArr2Y :
prepare_bresrun_Lbresfill138
prepare_bresrun_Lbresfill136
prepare_bresrun_Lbresfill130
; #ifdef USE_PROFILER
; PROFILE_LEAVE(ROUTINE_PREPAREBRESRUN)
; #endif
.)
	rts :
#endif



#ifdef USE_ASM_FILL8
_fill8:


	// save context
    ;pha
	;lda reg0: pha: lda reg1 : pha 

    // prepare_bresrun();
	ldy #0 : jsr _prepare_bresrun :

    // if (pDepY != pArr1Y) {
	lda _pDepY
	cmp _pArr1Y
	bne fill8_DepYDiffArr1Y
	jmp fill8_DepYEqualsArr1Y
fill8_DepYDiffArr1Y:
    //     A1X     = pDepX;
    //     A2X     = pDepX;
    //     A1Y     = pDepY;
    //     A2Y     = pDepY;
		lda _pDepX: sta _A1X: sta _A2X
		lda _pDepY: sta _A1Y: sta _A2Y

    //     A1destX = pArr1X;
    //     A1destY = pArr1Y;
		lda _pArr1X : sta _A1destX
		lda _pArr1Y : sta _A1destY

    //     A1dX    = abs(A1destX - A1X);
    //     A1sX      = (A1X < A1destX) ? 1 : -1;
		sec
		lda _A1X
		sbc _A1destX

		bmi fill8_01_negativ_02
		sta _A1dX
		lda #$FF
		sta _A1sX
    	lda #OPCODE_DEC_ZERO
    	sta _patch_A1stepY_incdec_A1X
		jmp fill8_computeDy_01
	fill8_01_negativ_02:
		eor #$FF
		sec
		adc #0
		sta _A1dX
		lda #$01
		sta _A1sX
    	lda #OPCODE_INC_ZERO
    	sta _patch_A1stepY_incdec_A1X


fill8_computeDy_01:		
    //     A1dY    = -abs(A1destY - A1Y);
    //     A1sY      = (A1Y < A1destY) ? 1 : -1;
		sec
		lda _A1Y
		sbc _A1destY
.(
		bmi fill8_02_negativ_02
		eor #$FF
		sec
		adc #0
		sta _A1dY
		lda #$FF 
		sta _A1sY
    	; lda #OPCODE_DEC_ZERO
    	; sta patch_A1StepY_incdec_A1Y
		jmp fill8_computeErr_01
	fill8_02_negativ_02:
		sta _A1dY
    	lda #$01
    	sta _A1sY
    	; lda #OPCODE_INC_ZERO
    	; sta patch_A1StepY_incdec_A1Y
.)

fill8_computeErr_01:
    //     A1err   = A1dX + A1dY;
		clc
		lda _A1dX
		adc _A1dY
		sta _A1err

    //     if ((A1err > 64) || (A1err < -63))
    //         return;

	    sec
		sbc #$40
		bvc *+4
		eor #$80
		bmi fill8_goon_01
		jmp fill8_done
fill8_goon_01:
		lda _A1err
		sec
		sbc #$C0
		bvc *+4
		eor #$80
		bpl fill8_goon_02
		jmp fill8_done
fill8_goon_02:
    //     A1arrived = ((A1X == A1destX) && (A1Y == A1destY)) ? 1 : 0;
		lda #0
		sta _A1arrived
		
		lda _A1X
		cmp _A1destX
		bne fill8_computeA2
		
		lda _A1Y
		cmp _A1destY
		bne fill8_computeA2
	
		lda #1
		sta _A1arrived

fill8_computeA2:
    //     A2destX = pArr2X;
	lda _pArr2X : sta _A2destX
    //     A2destY = pArr2Y;
	lda _pArr2Y : sta _A2destY
    //     A2dX    = abs(A2destX - A2X);
    //     A2sX      = (A2X < A2destX) ? 1 : -1;
		sec
		lda _A2X
		sbc _A2destX

		bmi fill8_03_negativ_02
		sta _A2dX
		lda #$FF
		sta _A2sX
		lda #OPCODE_DEC_ZERO
		sta patch_A2stepY_incdec_A2X
		jmp fill8_computeDy_02
	fill8_03_negativ_02:
		eor #$FF
		sec
		adc #0
		sta _A2dX
		lda #$01
		sta _A2sX
		lda #OPCODE_INC_ZERO
		sta patch_A2stepY_incdec_A2X

fill8_computeDy_02:
    //     A2dY    = -abs(A2destY - A2Y);
    //     A2sY      = (A2Y < A2destY) ? 1 : -1;
		sec
		lda _A2Y
		sbc _A2destY
.(
		bmi fill8_04_negativ_02
		eor #$FF
		sec
		adc #0
		sta _A2dY
		lda #$FF 
		sta _A2sY
		jmp fill8_computeErr_02
	fill8_04_negativ_02:
		sta _A2dY
    	lda #$01
    	sta _A2sY
.)

fill8_computeErr_02:

    //     A2err   = A2dX + A2dY;
		clc
		lda _A2dX
		adc _A2dY
		sta _A2err

    //     if ((A2err > 64) || (A2err < -63))
    //         return;
.(
	    sec
		sbc #$40
		bvc *+4
		eor #$80
		bmi fill8_tmp02
		jmp fill8_done
fill8_tmp02:
		lda _A2err
		sec
		sbc #$C0
		bvc *+4
		eor #$80
		bpl fill8_tmp03
		jmp fill8_done
fill8_tmp03:
.)
    //     A2arrived = ((A2X == A2destX) && (A2Y == A2destY)) ? 1 : 0;
		lda #0
		sta _A2arrived
		
		lda _A2X
		cmp _A2destX
		bne fill8_brestep1
		
		lda _A2Y
		cmp _A2destY
		bne fill8_brestep1
	
		lda #1
		sta _A2arrived

fill8_brestep1:
    //     bresStepType1();
		ldy #0 : jsr _bresStepType1

    //     A1X       = pArr1X;
	lda _pArr1X: sta _A1X
    //     A1Y       = pArr1Y;
	lda _pArr1Y: sta _A1Y
    //     A1destX   = pArr2X;
	lda _pArr2X : sta _A1destX
    //     A1destY   = pArr2Y;
	lda _pArr2Y : sta _A1destY

    //     A1dX    = abs(A1destX - A1X);
    //     A1sX      = (A1X < A1destX) ? 1 : -1;
		sec
		lda _A1X
		sbc _A1destX
.(
		bmi fill8_05_negativ_02
		sta _A1dX
		lda #$FF
		sta _A1sX
    	lda #OPCODE_DEC_ZERO
    	sta _patch_A1stepY_incdec_A1X
		jmp fill8_computeDy_03
	fill8_05_negativ_02:
		eor #$FF
		sec
		adc #0
		sta _A1dX
		lda #$01
		sta _A1sX
    	lda #OPCODE_INC_ZERO
    	sta _patch_A1stepY_incdec_A1X
.)

fill8_computeDy_03:		

    //     A1dY      = -abs(A1destY - A1Y);
    //     A1sY      = (A1Y < A1destY) ? 1 : -1;
		sec
		lda _A1Y
		sbc _A1destY
.(
		bmi fill8_06_negativ_02
		eor #$FF
		sec
		adc #0
		sta _A1dY
		lda #$FF 
		sta _A1sY
    	; lda #OPCODE_DEC_ZERO
    	; sta patch_A1StepY_incdec_A1Y
		jmp fill8_computeErr_03
	fill8_06_negativ_02:
		sta _A1dY
    	lda #$01
    	sta _A1sY
    	; lda #OPCODE_INC_ZERO
    	; sta patch_A1StepY_incdec_A1Y
.)

fill8_computeErr_03:

    //     A1err     = A1dX + A1dY;
		clc
		lda _A1dX
		adc _A1dY
		sta _A1err

    //     A1arrived = ((A1X == A1destX) && (A1Y == A1destY)) ? 1 : 0;
		lda #0
		sta _A1arrived
		
		lda _A1X
		cmp _A1destX
		bne fill8_brestep2
		
		lda _A1Y
		cmp _A1destY
		bne fill8_brestep2
	
		lda #1
		sta _A1arrived

fill8_brestep2:
    //     bresStepType2();
		ldy #0 : jsr _bresStepType2

		jmp fill8_done

fill8_DepYEqualsArr1Y:
    // } else {
    //     // a1 = bres_agent(pDep[0],pDep[1],pArr2[0],pArr2[1])
    //     A1X     = pDepX;
		lda _pDepX: sta _A1X
    //     A1Y     = pDepY;
		lda _pDepY: sta _A1Y
    //     A1destX = pArr2X;
		lda _pArr2X : sta _A1destX
    //     A1destY = pArr2Y;
		lda _pArr2Y : sta _A1destY

    //     A1dX    = abs(A1destX - A1X);
    //     A1sX = (A1X < A1destX) ? 1 : -1;
		sec
		lda _A1X
		sbc _A1destX
.(
		bmi fill8_07_negativ_02
		sta _A1dX
		lda #$FF
		sta _A1sX
    	lda #OPCODE_DEC_ZERO
    	sta _patch_A1stepY_incdec_A1X
		jmp fill8_computeDy_04
	fill8_07_negativ_02:
		eor #$FF
		sec
		adc #0
		sta _A1dX
		lda #$01
		sta _A1sX
    	lda #OPCODE_INC_ZERO
    	sta _patch_A1stepY_incdec_A1X
.)
fill8_computeDy_04:
    //     A1dY    = -abs(A1destY - A1Y);
    //     A1sY = (A1Y < A1destY) ? 1 : -1;
		sec
		lda _A1Y
		sbc _A1destY
.(
		bmi fill8_08_negativ_02
		eor #$FF
		sec
		adc #0
		sta _A1dY
		lda #$FF 
		sta _A1sY
    	; lda #OPCODE_DEC_ZERO
    	; sta patch_A1StepY_incdec_A1Y
		jmp fill8_computeErr_05
	fill8_08_negativ_02:
		sta _A1dY
    	lda #$01
    	sta _A1sY
    	; lda #OPCODE_INC_ZERO
    	; sta patch_A1StepY_incdec_A1Y
.)

fill8_computeErr_05:

    //     A1err   = A1dX + A1dY;
		clc
		lda _A1dX
		adc _A1dY
		sta _A1err

    //     if ((A1err > 64) || (A1err < -63))
    //         return;
	    sec
		sbc #$40
		bvc *+4
		eor #$80
		bmi fill8_goon_05
		jmp fill8_done
fill8_goon_05:
		lda _A1err
		sec
		sbc #$C0
		bvc *+4
		eor #$80
		bpl fill8_goon_06
		jmp fill8_done
fill8_goon_06

    //     A1arrived = ((A1X == A1destX) && (A1Y == A1destY)) ? 1 : 0;
		lda #0
		sta _A1arrived
		
		lda _A1X
		cmp _A1destX
		bne fill8_computeA2_ter
		
		lda _A1Y
		cmp _A1destY
		bne fill8_computeA2_ter
	
		lda #1
		sta _A1arrived

fill8_computeA2_ter:
    //     A2X     = pArr1X;
		lda _pArr1X : sta _A2X
    //     A2Y     = pArr1Y;
		lda _pArr1Y : sta _A2Y
    //     A2destX = pArr2X;
		lda _pArr2X : sta _A2destX
    //     A2destY = pArr2Y;
		lda _pArr2Y : sta _A2destY

    //     A2dX    = abs(A2destX - A2X);
    //     A2sX      = (A2X < A2destX) ? 1 : -1;
		sec
		lda _A2X
		sbc _A2destX

		bmi fill8_09_negativ_02
		sta _A2dX
		lda #$FF
		sta _A2sX
		lda #OPCODE_DEC_ZERO
		sta patch_A2stepY_incdec_A2X
		jmp fill8_computeDy_02
	fill8_09_negativ_02:
		eor #$FF
		sec
		adc #0
		sta _A2dX
		lda #$01
		sta _A2sX
		lda #OPCODE_INC_ZERO
		sta patch_A2stepY_incdec_A2X

fill8_computeDy_08:
    //     A2dY    = -abs(A2destY - A2Y);
    //     A2sY      = (A2Y < A2destY) ? 1 : -1;
		sec
		lda _A2Y
		sbc _A2destY
.(
		bmi fill8_10_negativ_02
		eor #$FF
		sec
		adc #0
		sta _A2dY
		lda #$FF 
		sta _A2sY
		jmp fill8_computeErr_09
	fill8_10_negativ_02:
		sta _A2dY
    	lda #$01
    	sta _A2sY
.)

fill8_computeErr_09:
    //     A2err   = A2dX + A2dY;
		clc
		lda _A2dX
		adc _A2dY
		sta _A2err

    //     if ((A2err > 64) || (A2err < -63))
    //         return;
	    sec
		sbc #$40
		bvc *+4
		eor #$80
		bmi fill8_tmp07
		jmp fill8_done
fill8_tmp07:
		lda _A2err
		sec
		sbc #$C0
		bvc *+4
		eor #$80
		bpl fill8_tmp08
		jmp fill8_done
fill8_tmp08:

    //     A2arrived = ((A2X == A2destX) && (A2Y == A2destY)) ? 1 : 0;
		lda #0
		sta _A2arrived
		
		lda _A2X
		cmp _A2destX
		bne fill8_brestep3
		
		lda _A2Y
		cmp _A2destY
		bne fill8_brestep3
	
		lda #1
		sta _A2arrived

fill8_brestep3:
    //     bresStepType3() ;
		ldy #0 : jsr _bresStepType3
    // }

fill8_done:
	// restore context
	;pla: sta reg1: pla: sta reg0
	;pla


	rts
#endif USE_ASM_FILL8