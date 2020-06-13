
; USE_ASM_BRESFILL 
; _A1stepY
; _A2stepY
; _hfill
; _angle2screen
; _prepare_bresrun
; _isA1Right1
; _isA1Right3
; _fill8
; _bresStepType1
; _bresStepType2
; _bresStepType3
; _reachScreen
; _fillFace

#include "config.h"
#ifdef USE_PROFILER
#include "profile.h"
#endif 


#define OPCODE_DEC_ZERO $C6
#define OPCODE_INC_ZERO $E6

#ifndef TARGET_ORIX                                            
#ifdef SAVE_ZERO_PAGE
.text
#else
.zero
#endif
#else
.text
#endif ;; TARGET_ORIX

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

_A1Right .dsb 1

#ifdef SAVE_ZERO_PAGE
.text
#endif
_mDeltaY1 .dsb 1
_mDeltaX1 .dsb 1
_mDeltaY2 .dsb 1
_mDeltaX2 .dsb 1

#ifdef USE_SATURATION
_A1XSatur .dsb 1
_A2XSatur .dsb 1
#endif


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

.text

#ifdef TARGET_ORIX
reg0 .dsb 2
reg1 .dsb 2
#endif
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

	;; save context
    pha
	lda reg0: pha: lda reg1 : pha 

	;; nxtY = A1Y+A1sY;
	clc
	lda _A1Y
	adc _A1sY
	sta reg1
	
	;; e2 = A1err << 1; ;; 2*A1err;
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
    .(:bvc skip : eor #$80: skip:.)
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
        .(:bvc skip : eor #$80: skip:.)
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
#ifdef USE_PATCHED_AGENT
_patch_A1stepY_incdec_A1X:
			inc _A1X 
#else
			clc
			lda _A1X
			adc _A1sX
			sta _A1X
#endif ;; USE_PATCHED_AGENT
		;; }
A1stepY_A1Xdone:
		;; if (e2 <= A1dX){
		lda _A1dX
        sec
		sbc reg0
        .(:bvc skip : eor #$80: skip:.)
		bmi A1stepY_A1Ydone
		;; 	A1err += A1dX;
			clc
			lda _A1err
			adc _A1dX
			sta _A1err
		;; 	A1Y += A1sY; ;; Optim:  substraction by dec _A1Y
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
		;; e2 = A1err << 1; ;; 2*A1err;
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

	;; restore context
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

	;; save context
    pha
	lda reg0: pha: lda reg1 : pha 

	;; nxtY = A2Y+A2sY;
	clc
	lda _A2Y
	adc _A2sY
	sta reg1
	
	;; e2 = A2err << 1; ;; 2*A2err;
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
    .(:bvc skip : eor #$80: skip:.)
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
        .(:bvc skip : eor #$80: skip:.)
		bmi A2stepY_A2Xdone
		;; 	A2err += A2dY;
			clc
			lda _A2err
			adc _A2dY
			sta _A2err
		;; 	A2X += A2sX;
#ifdef USE_PATCHED_AGENT
patch_A2stepY_incdec_A2X:
			inc _A2X
#else
			clc
			lda _A2X
			adc _A2sX
			sta _A2X
#endif ;; USE_PATCHED_AGENT
		;; }
A2stepY_A2Xdone:
		;; if (e2 <= A2dX){
		lda _A2dX
        sec
        sbc reg0
        .(:bvc skip : eor #$80: skip:.)
		bmi A2stepY_A2Ydone
		;; 	A2err += A2dX;
			clc
			lda _A2err
			adc _A2dX
			sta _A2err
		;; 	A2Y += A2sY; ;; ;; Optim:  substraction dec _A2Y
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
		;; e2 = A2err << 1; ;; 2*A2err;
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

	;; restore context
	pla: sta reg1: pla: sta reg0
	pla


	rts
#endif ;;  USE_ASM_BRESFILL

#ifdef USE_ASM_FILL8
_fill8:


	;; save context
    ;pha
	;lda reg0: pha: lda reg1 : pha 

    ;; prepare_bresrun();
	ldy #0 : jsr _prepare_bresrun :

    ;; if (pDepY != pArr1Y) {
	lda _pDepY
	cmp _pArr1Y
	bne fill8_DepYDiffArr1Y
	jmp fill8_DepYEqualsArr1Y
fill8_DepYDiffArr1Y:
    ;;     A1X     = pDepX;
    ;;     A2X     = pDepX;
    ;;     A1Y     = pDepY;
    ;;     A2Y     = pDepY;
		lda _pDepX: sta _A1X: sta _A2X
		lda _pDepY: sta _A1Y: sta _A2Y

    ;;     A1destX = pArr1X;
    ;;     A1destY = pArr1Y;
		lda _pArr1X : sta _A1destX
		lda _pArr1Y : sta _A1destY

    ;;     A1dX    = abs(A1destX - A1X);
    ;;     A1sX      = (A1X < A1destX) ? 1 : -1;
		sec
		lda _A1X
		sbc _A1destX

		sta _mDeltaX1

		bmi fill8_01_negativ_02
		sta _A1dX
		lda #$FF
		sta _A1sX
    	lda #OPCODE_DEC_ZERO
#ifdef USE_PATCHED_AGENT
    	sta _patch_A1stepY_incdec_A1X
#ifdef USE_SATURATION		
		sta _patch_A1stepY_A1Right_incdec_A1X
		sta _patch_A1stepY_A1Left_incdec_A1X
#endif 
#endif ;; USE_PATCHED_AGENT
		jmp fill8_computeDy_01
	fill8_01_negativ_02:
		eor #$FF
		sec
		adc #0
		sta _A1dX
		lda #$01
		sta _A1sX
    	lda #OPCODE_INC_ZERO
#ifdef USE_PATCHED_AGENT
    	sta _patch_A1stepY_incdec_A1X
#ifdef USE_SATURATION		
		sta _patch_A1stepY_A1Right_incdec_A1X
		sta _patch_A1stepY_A1Left_incdec_A1X
#endif ;; USE_SATURATION
#endif ;; USE_PATCHED_AGENT

fill8_computeDy_01:		
    ;;     A1dY    = -abs(A1destY - A1Y);
    ;;     A1sY      = (A1Y < A1destY) ? 1 : -1;
		sec
		lda _A1Y
		sbc _A1destY
		sta _mDeltaY1
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
    ;;     A1err   = A1dX + A1dY;
		clc
		lda _A1dX
		adc _A1dY
		sta _A1err

    ;;     if ((A1err > 64) || (A1err < -63))
    ;;         return;

	    sec
		sbc #$40
		.(:bvc skip : eor #$80: skip:.)
		bmi fill8_goon_01
		jmp fill8_done
fill8_goon_01:
		lda _A1err
		sec
		sbc #$C0
		.(:bvc skip : eor #$80: skip:.)
		bpl fill8_goon_02
		jmp fill8_done
fill8_goon_02:
    ;;     A1arrived = ((A1X == A1destX) && (A1Y == A1destY)) ? 1 : 0;
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
    ;;     A2destX = pArr2X;
	lda _pArr2X : sta _A2destX
    ;;     A2destY = pArr2Y;
	lda _pArr2Y : sta _A2destY
    ;;     A2dX    = abs(A2destX - A2X);
    ;;     A2sX      = (A2X < A2destX) ? 1 : -1;
		sec
		lda _A2X
		sbc _A2destX

		sta _mDeltaX2

		bmi fill8_03_negativ_02
		sta _A2dX
		lda #$FF
		sta _A2sX
		lda #OPCODE_DEC_ZERO
#ifdef USE_PATCHED_AGENT
		sta patch_A2stepY_incdec_A2X
#ifdef USE_SATURATION
		sta _patch_A2stepY_A1Right_incdec_A2X
		sta _patch_A2stepY_A1Left_incdec_A2X
#endif ;; USE_SATURATION
#endif ;; USE_PATCHED_AGENT
		jmp fill8_computeDy_02
	fill8_03_negativ_02:
		eor #$FF
		sec
		adc #0
		sta _A2dX
		lda #$01
		sta _A2sX
		lda #OPCODE_INC_ZERO
#ifdef USE_PATCHED_AGENT
		sta patch_A2stepY_incdec_A2X
#ifdef USE_SATURATION		
		sta _patch_A2stepY_A1Right_incdec_A2X
		sta _patch_A2stepY_A1Left_incdec_A2X
#endif ;; USE_SATURATION
#endif ;; USE_PATCHED_AGENT
fill8_computeDy_02:
    ;;     A2dY    = -abs(A2destY - A2Y);
    ;;     A2sY      = (A2Y < A2destY) ? 1 : -1;
		sec
		lda _A2Y
		sbc _A2destY
		sta _mDeltaY2
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

    ;;     A2err   = A2dX + A2dY;
		clc
		lda _A2dX
		adc _A2dY
		sta _A2err

    ;;     if ((A2err > 64) || (A2err < -63))
    ;;         return;
.(
	    sec
		sbc #$40
		.(:bvc skip : eor #$80: skip:.)
		bmi fill8_tmp02
		jmp fill8_done
fill8_tmp02:
		lda _A2err
		sec
		sbc #$C0
		.(:bvc skip : eor #$80: skip:.)
		bpl fill8_tmp03
		jmp fill8_done
fill8_tmp03:
.)
    ;;     A2arrived = ((A2X == A2destX) && (A2Y == A2destY)) ? 1 : 0;
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
   ;;     isA1Right1();
		ldy #0 : jsr _isA1Right1
    ;;     bresStepType1();
		ldy #0 : jsr _bresStepType1

    ;;     A1X       = pArr1X;
	lda _pArr1X: sta _A1X
    ;;     A1Y       = pArr1Y;
	lda _pArr1Y: sta _A1Y
    ;;     A1destX   = pArr2X;
	lda _pArr2X : sta _A1destX
    ;;     A1destY   = pArr2Y;
	lda _pArr2Y : sta _A1destY

    ;;     A1dX    = abs(A1destX - A1X);
    ;;     A1sX      = (A1X < A1destX) ? 1 : -1;
		sec
		lda _A1X
		sbc _A1destX
.(
		bmi fill8_05_negativ_02
		sta _A1dX
		lda #$FF
		sta _A1sX
    	lda #OPCODE_DEC_ZERO
#ifdef USE_PATCHED_AGENT
    	sta _patch_A1stepY_incdec_A1X
#ifdef USE_SATURATION
		sta _patch_A1stepY_A1Right_incdec_A1X
		sta _patch_A1stepY_A1Left_incdec_A1X
#endif ;; USE_SATURATION
#endif ;; USE_PATCHED_AGENT

		jmp fill8_computeDy_03
	fill8_05_negativ_02:
		eor #$FF
		sec
		adc #0
		sta _A1dX
		lda #$01
		sta _A1sX
    	lda #OPCODE_INC_ZERO
#ifdef USE_PATCHED_AGENT
    	sta _patch_A1stepY_incdec_A1X
#ifdef USE_SATURATION
		sta _patch_A1stepY_A1Right_incdec_A1X
		sta _patch_A1stepY_A1Left_incdec_A1X
#endif ;; USE_SATURATION
#endif ;; USE_PATCHED_AGENT


.)

fill8_computeDy_03:		

    ;;     A1dY      = -abs(A1destY - A1Y);
    ;;     A1sY      = (A1Y < A1destY) ? 1 : -1;
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

    ;;     A1err     = A1dX + A1dY;
		clc
		lda _A1dX
		adc _A1dY
		sta _A1err

    ;;     A1arrived = ((A1X == A1destX) && (A1Y == A1destY)) ? 1 : 0;
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
    ;;     bresStepType2();
		ldy #0 : jsr _bresStepType2

		jmp fill8_done

fill8_DepYEqualsArr1Y:
    ;; } else {
    ;;     ;; a1 = bres_agent(pDep[0],pDep[1],pArr2[0],pArr2[1])
    ;;     A1X     = pDepX;
		lda _pDepX: sta _A1X
    ;;     A1Y     = pDepY;
		lda _pDepY: sta _A1Y
    ;;     A1destX = pArr2X;
		lda _pArr2X : sta _A1destX
    ;;     A1destY = pArr2Y;
		lda _pArr2Y : sta _A1destY

    ;;     A1dX    = abs(A1destX - A1X);
    ;;     A1sX = (A1X < A1destX) ? 1 : -1;
		sec
		lda _A1X
		sbc _A1destX
.(
		bmi fill8_07_negativ_02
		sta _A1dX
		lda #$FF
		sta _A1sX
    	lda #OPCODE_DEC_ZERO
#ifdef USE_PATCHED_AGENT
    	sta _patch_A1stepY_incdec_A1X
#ifdef USE_SATURATION
		sta _patch_A1stepY_A1Right_incdec_A1X
		sta _patch_A1stepY_A1Left_incdec_A1X
#endif ;; USE_SATURATION
#endif ;; USE_PATCHED_AGENT
		jmp fill8_computeDy_04
	fill8_07_negativ_02:
		eor #$FF
		sec
		adc #0
		sta _A1dX
		lda #$01
		sta _A1sX
    	lda #OPCODE_INC_ZERO
#ifdef USE_PATCHED_AGENT
    	sta _patch_A1stepY_incdec_A1X
#ifdef USE_SATURATION
		sta _patch_A1stepY_A1Right_incdec_A1X
		sta _patch_A1stepY_A1Left_incdec_A1X
#endif ;; USE_SATURATION
#endif ;; USE_PATCHED_AGENT
.)
fill8_computeDy_04:
    ;;     A1dY    = -abs(A1destY - A1Y);
    ;;     A1sY = (A1Y < A1destY) ? 1 : -1;
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

    ;;     A1err   = A1dX + A1dY;
		clc
		lda _A1dX
		adc _A1dY
		sta _A1err

    ;;     if ((A1err > 64) || (A1err < -63))
    ;;         return;
	    sec
		sbc #$40
		.(:bvc skip : eor #$80: skip:.)
		bmi fill8_goon_05
		jmp fill8_done
fill8_goon_05:
		lda _A1err
		sec
		sbc #$C0
		.(:bvc skip : eor #$80: skip:.)
		bpl fill8_goon_06
		jmp fill8_done
fill8_goon_06

    ;;     A1arrived = ((A1X == A1destX) && (A1Y == A1destY)) ? 1 : 0;
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
    ;;     A2X     = pArr1X;
		lda _pArr1X : sta _A2X
    ;;     A2Y     = pArr1Y;
		lda _pArr1Y : sta _A2Y
    ;;     A2destX = pArr2X;
		lda _pArr2X : sta _A2destX
    ;;     A2destY = pArr2Y;
		lda _pArr2Y : sta _A2destY

    ;;     A2dX    = abs(A2destX - A2X);
    ;;     A2sX      = (A2X < A2destX) ? 1 : -1;
		sec
		lda _A2X
		sbc _A2destX

		bmi fill8_09_negativ_02
		sta _A2dX
		lda #$FF
		sta _A2sX
		lda #OPCODE_DEC_ZERO
#ifdef USE_PATCHED_AGENT
		sta patch_A2stepY_incdec_A2X
#ifdef USE_SATURATION
		sta _patch_A2stepY_A1Right_incdec_A2X
		sta _patch_A2stepY_A1Left_incdec_A2X
#endif ;; USE_SATURATION
#endif ;; USE_PATCHED_AGENT
		jmp fill8_computeDy_08
	fill8_09_negativ_02:
		eor #$FF
		sec
		adc #0
		sta _A2dX
		lda #$01
		sta _A2sX
		lda #OPCODE_INC_ZERO
#ifdef USE_PATCHED_AGENT
		sta patch_A2stepY_incdec_A2X
#ifdef USE_SATURATION
		sta _patch_A2stepY_A1Right_incdec_A2X
		sta _patch_A2stepY_A1Left_incdec_A2X
#endif ;; USE_SATURATION
#endif ;; USE_PATCHED_AGENT
fill8_computeDy_08:
    ;;     A2dY    = -abs(A2destY - A2Y);
    ;;     A2sY      = (A2Y < A2destY) ? 1 : -1;
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
    ;;     A2err   = A2dX + A2dY;
		clc
		lda _A2dX
		adc _A2dY
		sta _A2err

    ;;     if ((A2err > 64) || (A2err < -63))
    ;;         return;
	    sec
		sbc #$40
		.(:bvc skip : eor #$80: skip:.)
		bmi fill8_tmp07
		jmp fill8_done
fill8_tmp07:
		lda _A2err
		sec
		sbc #$C0
		.(:bvc skip : eor #$80: skip:.)
		bpl fill8_tmp08
		jmp fill8_done
fill8_tmp08:

    ;;     A2arrived = ((A2X == A2destX) && (A2Y == A2destY)) ? 1 : 0;
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
   ;;     isA1Right3();
		ldy #0 : jsr _isA1Right3
    ;;     bresStepType3() ;
		ldy #0 : jsr _bresStepType3
    ;; }

fill8_done:
	;; restore context
	;pla: sta reg1: pla: sta reg0
	;pla


	rts
#endif USE_ASM_FILL8


#ifndef USE_SATURATION

#ifdef USE_ASM_BRESTYPE1
;; void bresStepType1()
_bresStepType1:
.(
	ldy #0 : jsr _reachScreen :
	ldy #0 : jsr _hzfill :
	jmp bresStepType1_Lbresfill133 :
bresStepType1_Lbresfill132
	ldy #0 : jsr _A1stepY :
	ldy #0 : jsr _A2stepY :
	ldy #0 : jsr _hzfill :
bresStepType1_Lbresfill133
	lda _A1arrived : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : ora tmp0+1 : beq *+5 : jmp bresStepType1_Lbresfill135 :
	lda _A1Y : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #<(1) : cmp tmp0 : lda #>(1) : sbc tmp0+1 : .( : bvc *+4 : eor #$80 : bpl skip : jmp bresStepType1_Lbresfill132 :skip : .) : : :
bresStepType1_Lbresfill135
.)
	rts
#endif ;; USE_ASM_BRESTYPE1

#ifdef USE_ASM_BRESTYPE2
;; void bresStepType2()
_bresStepType2:
.(
	jmp bresStepType2_Lbresfill137 :
bresStepType2_Lbresfill136
	ldy #0 : jsr _A1stepY :
	ldy #0 : jsr _A2stepY :
	ldy #0 : jsr _hzfill :
bresStepType2_Lbresfill137
	lda _A1arrived : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : ora tmp0+1 : beq *+5 : jmp bresStepType2_Lbresfill140 :
	lda _A2arrived : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : ora tmp0+1 : beq *+5 : jmp bresStepType2_Lbresfill140 :
	lda _A1Y : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #<(1) : cmp tmp0 : lda #>(1) : sbc tmp0+1 : .( : bvc *+4 : eor #$80 : bpl skip : jmp bresStepType2_Lbresfill136 :skip : .) : : :
bresStepType2_Lbresfill140
.)
	rts
#endif ;; USE_ASM_BRESTYPE2

#ifdef USE_ASM_BRESTYPE3
;; void bresStepType3()
_bresStepType3:
.(
	ldy #0 : jsr _reachScreen :
	ldy #0 : jsr _hzfill :
	jmp bresStepType3_Lbresfill142 :
bresStepType3_Lbresfill141
	ldy #0 : jsr _A1stepY :
	ldy #0 : jsr _A2stepY :
	ldy #0 : jsr _hzfill :
bresStepType3_Lbresfill142
	lda _A1arrived : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : ora tmp0+1 : beq *+5 : jmp bresStepType3_Lbresfill145 :
	lda _A2arrived : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : ora tmp0+1 : beq *+5 : jmp bresStepType3_Lbresfill145 :
	lda _A1Y : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #<(1) : cmp tmp0 : lda #>(1) : sbc tmp0+1 : .( : bvc *+4 : eor #$80 : bpl skip : jmp bresStepType3_Lbresfill141 :skip : .) : : :
bresStepType3_Lbresfill145
.)
	rts
#endif ;; USE_ASM_BRESTYPE3

#endif ;; USE_SATURATION
