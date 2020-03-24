
#include "config.h"

;;**************************
;;**************************
;;        RASTER8
;;**************************
;;**************************

#ifdef USE_SATURATION

#ifdef USE_ASM_BRESFILL

;;**************************
;;
;;**************************
#ifdef USE_ASM_AGENTSTEP

_A1stepY_A1Right:

#ifdef SAFE_CONTEXT
	// save context
    pha
	lda tmp5 : pha      ; e2
	lda tmp5+1 : pha    ; nxtY
#endif // SAFE_CONTEXT

	;; nxtY = A1Y+A1sY;
	clc
	lda _A1Y
	adc _A1sY
	sta tmp5+1
	
	;; e2 = A1err << 1; // 2*A1err;
	lda _A1err
	bpl A1stepY_A1Right_errpositiv_01
	asl
	bmi A1stepY_A1Right_errdone_01
	lda #$80
	jmp A1stepY_A1Right_errdone_01
	
A1stepY_A1Right_errpositiv_01:	
	asl
	bpl A1stepY_A1Right_errdone_01
	lda #$7F
A1stepY_A1Right_errdone_01:	
	sta tmp5
	
	;; while ((A1arrived == 0) && ((e2>A1dX) || (A1Y!=nxtY))){
A1stepY_A1Right_loop:
	lda _A1arrived ;; (A1arrived == 0)
	beq A1stepY_A1Right_notarrived
	jmp A1stepY_A1Rightdone

A1stepY_A1Right_notarrived:	
	lda _A1dX 		;; (e2>A1dX)
    sec
	sbc tmp5
    bvc *+4
    eor #$80
	bmi A1stepY_A1Right_doloop

	lda tmp5+1 		;; (A1Y!=nxtY)
	cmp _A1Y
	bne A1stepY_A1Right_doloop
	
	jmp A1stepY_A1Rightdone
A1stepY_A1Right_doloop:
	
		;; if (e2 >= A1dY){
		lda tmp5 ; e2
        sec
        sbc _A1dY
        bvc *+4
        eor #$80
		bmi A1stepY_A1Right_A1Xdone
		;; 	A1err += A1dY;
			clc
			lda _A1err
			adc _A1dY
			bvc A1stepY_A1Right_debug_moi_la
			jmp A1stepY_A1Rightdone
A1stepY_A1Right_debug_moi_la:			
			sta _A1err
		;; 	A1X += A1sX;
// OPTIM TO TEST
; _patch_A1stepY_A1Right_incdec_A1X:
;  			inc _A1X : lda _A1X
			clc
			lda _A1X
			adc _A1sX
			sta _A1X

            ;; TOTEST if (A1X == SCREEN_WIDTH - 1){
            cmp #SCREEN_WIDTH-1
            bne A1stepY_A1Right_DntSwitch
            ;;     switch_A1XSatur();
                lda _A1XSatur
                eor #$01
                sta _A1XSatur
A1stepY_A1Right_DntSwitch:
            ;; }

		;; }
A1stepY_A1Right_A1Xdone:
		;; if (e2 <= A1dX){
		lda _A1dX
        sec
		sbc tmp5
        bvc *+4
        eor #$80
		bmi A1stepY_A1Right_A1Ydone
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
A1stepY_A1Right_A1Ydone:
		;; A1arrived=((A1X == A1destX) && ( A1Y == A1destY))?1:0;
		lda #0
		sta _A1arrived
		
		lda _A1X
		cmp _A1destX
		bne A1stepY_A1Right_computeE2
		
		lda _A1Y
		cmp _A1destY
		bne A1stepY_A1Right_computeE2
	
		lda #1
		sta _A1arrived
A1stepY_A1Right_computeE2:
		;; e2 = A1err << 1; // 2*A1err;
		lda _A1err
		bpl A1stepY_A1Right_errpositiv_02
		asl
		bmi A1stepY_A1Right_errdone_02
		lda #$80
		jmp A1stepY_A1Right_errdone_02
		
A1stepY_A1Right_errpositiv_02:	
		asl
		bpl A1stepY_A1Right_errdone_02
		lda #$7F
A1stepY_A1Right_errdone_02:	
		sta tmp5
	
	jmp A1stepY_A1Right_loop
A1stepY_A1Rightdone:	

#ifdef SAFE_CONTEXT
	// restore context
	pla: sta tmp5+1: pla: sta tmp5
	pla
#endif // SAFE_CONTEXT


	rts

;;**************************
;;
;;**************************

_A1stepY_A1Left:

#ifdef SAFE_CONTEXT
	// save context
    pha
	lda tmp5 : pha      ; e2
	lda tmp5+1 : pha    ; nxtY
#endif // SAFE_CONTEXT

	;; nxtY = A1Y+A1sY;
	clc
	lda _A1Y
	adc _A1sY
	sta tmp5+1
	
	;; e2 = A1err << 1; // 2*A1err;
	lda _A1err
	bpl A1stepY_A1Left_errpositiv_01
	asl
	bmi A1stepY_A1Left_errdone_01
	lda #$80
	jmp A1stepY_A1Left_errdone_01
	
A1stepY_A1Left_errpositiv_01:	
	asl
	bpl A1stepY_A1Left_errdone_01
	lda #$7F
A1stepY_A1Left_errdone_01:	
	sta tmp5
	
	;; while ((A1arrived == 0) && ((e2>A1dX) || (A1Y!=nxtY))){
A1stepY_A1Left_loop:
	lda _A1arrived ;; (A1arrived == 0)
	beq A1stepY_A1Left_notarrived
	jmp A1stepY_A1Leftdone

A1stepY_A1Left_notarrived:	
	lda _A1dX 		;; (e2>A1dX)
    sec
	sbc tmp5
    bvc *+4
    eor #$80
	bmi A1stepY_A1Left_doloop

	lda tmp5+1 		;; (A1Y!=nxtY)
	cmp _A1Y
	bne A1stepY_A1Left_doloop
	
	jmp A1stepY_A1Leftdone
A1stepY_A1Left_doloop:
	
		;; if (e2 >= A1dY){
		lda tmp5 ; e2
        sec
        sbc _A1dY
        bvc *+4
        eor #$80
		bmi A1stepY_A1Left_A1Xdone
		;; 	A1err += A1dY;
			clc
			lda _A1err
			adc _A1dY
			bvc A1stepY_A1Left_debug_moi_la
			jmp A1stepY_A1Leftdone
A1stepY_A1Left_debug_moi_la:			
			sta _A1err
		;; 	A1X += A1sX;
// OPTIM 
; _patch_A1stepY_A1Left_incdec_A1X:
;  			inc _A1X : lda _A1X
			clc
			lda _A1X
			adc _A1sX
			sta _A1X

// TOTEST: 
#ifdef USE_COLOR
            ;;if (A1X == COLUMN_OF_COLOR_ATTRIBUTE){
            cmp #COLUMN_OF_COLOR_ATTRIBUTE
            bne A1stepY_A1Left_DntSwitch
#else
            ;;if (A1X == 0){
            bne A1stepY_A1Left_DntSwitch
#endif
            ;;    switch_A1XSatur();
                lda _A1XSatur
                eor #$01
                sta _A1XSatur
A1stepY_A1Left_DntSwitch:
            ;;  }


		;; }
A1stepY_A1Left_A1Xdone:
		;; if (e2 <= A1dX){
		lda _A1dX
        sec
		sbc tmp5
        bvc *+4
        eor #$80
		bmi A1stepY_A1Left_A1Ydone
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
A1stepY_A1Left_A1Ydone:
		;; A1arrived=((A1X == A1destX) && ( A1Y == A1destY))?1:0;
		lda #0
		sta _A1arrived
		
		lda _A1X
		cmp _A1destX
		bne A1stepY_A1Left_computeE2
		
		lda _A1Y
		cmp _A1destY
		bne A1stepY_A1Left_computeE2
	
		lda #1
		sta _A1arrived
A1stepY_A1Left_computeE2:
		;; e2 = A1err << 1; // 2*A1err;
		lda _A1err
		bpl A1stepY_A1Left_errpositiv_02
		asl
		bmi A1stepY_A1Left_errdone_02
		lda #$80
		jmp A1stepY_A1Left_errdone_02
		
A1stepY_A1Left_errpositiv_02:	
		asl
		bpl A1stepY_A1Left_errdone_02
		lda #$7F
A1stepY_A1Left_errdone_02:	
		sta tmp5
	
	jmp A1stepY_A1Left_loop
A1stepY_A1Leftdone:	

#ifdef SAFE_CONTEXT
	// restore context
	pla: sta tmp5+1: pla: sta tmp5
	pla
#endif // SAFE_CONTEXT

	rts

;;**************************
;;
;;**************************

_A2stepY_A1Right:

#ifdef SAFE_CONTEXT
	// save context
    pha
	lda tmp5 : pha      ; e2
	lda tmp5+1 : pha    ; nxtY
#endif // SAFE_CONTEXT	;; nxtY = A2Y+A2sY;
	clc
	lda _A2Y
	adc _A2sY
	sta tmp5+1
	
	;; e2 = A2err << 1; // 2*A2err;
	lda _A2err
	bpl A2stepY_A1Right_errpositiv_01
	asl
	bmi A2stepY_A1Right_errdone_01
	lda #$80
	jmp A2stepY_A1Right_errdone_01
	
A2stepY_A1Right_errpositiv_01:	
	asl
	bpl A2stepY_A1Right_errdone_01
	lda #$7F
A2stepY_A1Right_errdone_01:	
	sta tmp5
	
	;; while ((A2arrived == 0) && ((e2>A2dX) || (A2Y!=nxtY))){
A2stepY_A1Right_loop:
	lda _A2arrived ;; (A2arrived == 0)
	beq A2stepY_A1Right_notarrived
	jmp A2stepY_A1Rightdone

A2stepY_A1Right_notarrived:	
	lda _A2dX 		;; (e2>A2dX)
    sec
    sbc tmp5
    bvc *+4
    eor #$80
	bmi A2stepY_A1Right_doloop

	lda tmp5+1 		;; (A2Y!=nxtY)
	cmp _A2Y
	bne A2stepY_A1Right_doloop
	
	jmp A2stepY_A1Rightdone
A2stepY_A1Right_doloop:
	
		;; if (e2 >= A2dY){
		lda tmp5 ; e2
        sec
        sbc _A2dY
        bvc *+4
        eor #$80
		bmi A2stepY_A1Right_A2Xdone
		;; 	A2err += A2dY;
			clc
			lda _A2err
			adc _A2dY
			sta _A2err
		;; 	A2X += A2sX;
//OPTIM : 
; _patch_A2stepY_A1Right_incdec_A2X:

;  			inc _A2X : lda _A2X
			clc
			lda _A2X
			adc _A2sX
			sta _A2X
// TOTEST
#ifdef USE_COLOR
        ;;    if (A2X == COLUMN_OF_COLOR_ATTRIBUTE){
            cmp #COLUMN_OF_COLOR_ATTRIBUTE
            bne A2stepY_A1Right_DntSwitch
#else
        ;;    if (A2X == 0){
            bne A2stepY_A1Right_DntSwitch
#endif
        ;;        switch_A2XSatur();
                lda _A2XSatur
                eor #$01
                sta _A2XSatur
A2stepY_A1Right_DntSwitch:
        ;;    }

		;; }
A2stepY_A1Right_A2Xdone:
		;; if (e2 <= A2dX){
		lda _A2dX
        sec
        sbc tmp5
        bvc *+4
        eor #$80
		bmi A2stepY_A1Right_A2Ydone
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
A2stepY_A1Right_A2Ydone:
		;; A2arrived=((A2X == A2destX) && ( A2Y == A2destY))?1:0;
		lda #0
		sta _A2arrived
		
		lda _A2X
		cmp _A2destX
		bne A2stepY_A1Right_computeE2
		
		lda _A2Y
		cmp _A2destY
		bne A2stepY_A1Right_computeE2
	
		lda #1
		sta _A2arrived
A2stepY_A1Right_computeE2:
		;; e2 = A2err << 1; // 2*A2err;
		lda _A2err
		bpl A2stepY_A1Right_errpositiv_02
		asl
		bmi A2stepY_A1Right_errdone_02
		lda #$80
		jmp A2stepY_A1Right_errdone_02
		
A2stepY_A1Right_errpositiv_02:	
		asl
		bpl A2stepY_A1Right_errdone_02
		lda #$7F
A2stepY_A1Right_errdone_02:	
		sta tmp5
	
	jmp A2stepY_A1Right_loop
A2stepY_A1Rightdone:	

#ifdef SAFE_CONTEXT
	// restore context
	pla: sta tmp5+1: pla: sta tmp5
	pla
#endif // SAFE_CONTEXT

	rts

;;**************************
;;
;;**************************

_A2stepY_A1Left:

#ifdef SAFE_CONTEXT
	// save context
    pha
	lda tmp5 : pha      ; e2
	lda tmp5+1 : pha    ; nxtY
#endif // SAFE_CONTEXT	;; nxtY = A2Y+A2sY;
	clc
	lda _A2Y
	adc _A2sY
	sta tmp5+1
	
	;; e2 = A2err << 1; // 2*A2err;
	lda _A2err
	bpl A2stepY_A1Left_errpositiv_01
	asl
	bmi A2stepY_A1Left_errdone_01
	lda #$80
	jmp A2stepY_A1Left_errdone_01
	
A2stepY_A1Left_errpositiv_01:	
	asl
	bpl A2stepY_A1Left_errdone_01
	lda #$7F
A2stepY_A1Left_errdone_01:	
	sta tmp5
	
	;; while ((A2arrived == 0) && ((e2>A2dX) || (A2Y!=nxtY))){
A2stepY_A1Left_loop:
	lda _A2arrived ;; (A2arrived == 0)
	beq A2stepY_A1Left_notarrived
	jmp A2stepY_A1Leftdone

A2stepY_A1Left_notarrived:	
	lda _A2dX 		;; (e2>A2dX)
    sec
    sbc tmp5
    bvc *+4
    eor #$80
	bmi A2stepY_A1Left_doloop

	lda tmp5+1 		;; (A2Y!=nxtY)
	cmp _A2Y
	bne A2stepY_A1Left_doloop
	
	jmp A2stepY_A1Leftdone
A2stepY_A1Left_doloop:
	
		;; if (e2 >= A2dY){
		lda tmp5 ; e2
        sec
        sbc _A2dY
        bvc *+4
        eor #$80
		bmi A2stepY_A1Left_A2Xdone
		;; 	A2err += A2dY;
			clc
			lda _A2err
			adc _A2dY
			sta _A2err
		;; 	A2X += A2sX;
//OPTIM : 
; _patch_A2stepY_A1Left_incdec_A2X:
; 			inc _A2X : lda _A2X
			clc
			lda _A2X
			adc _A2sX
			sta _A2X

        ;; TOTEST:   if (A2X == SCREEN_WIDTH - 1){
            cmp #SCREEN_WIDTH-1
            bne A2stepY_A1Left_DntSwitch
        ;;        switch_A2XSatur();
                lda _A2XSatur
                eor #$01
                sta _A2XSatur
A2stepY_A1Left_DntSwitch:
        ;;    }

		;; }
A2stepY_A1Left_A2Xdone:
		;; if (e2 <= A2dX){
		lda _A2dX
        sec
        sbc tmp5
        bvc *+4
        eor #$80
		bmi A2stepY_A1Left_A2Ydone
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
A2stepY_A1Left_A2Ydone:
		;; A2arrived=((A2X == A2destX) && ( A2Y == A2destY))?1:0;
		lda #0
		sta _A2arrived
		
		lda _A2X
		cmp _A2destX
		bne A2stepY_A1Left_computeE2
		
		lda _A2Y
		cmp _A2destY
		bne A2stepY_A1Left_computeE2
	
		lda #1
		sta _A2arrived
A2stepY_A1Left_computeE2:
		;; e2 = A2err << 1; // 2*A2err;
		lda _A2err
		bpl A2stepY_A1Left_errpositiv_02
		asl
		bmi A2stepY_A1Left_errdone_02
		lda #$80
		jmp A2stepY_A1Left_errdone_02
		
A2stepY_A1Left_errpositiv_02:	
		asl
		bpl A2stepY_A1Left_errdone_02
		lda #$7F
A2stepY_A1Left_errdone_02:	
		sta tmp5
	
	jmp A2stepY_A1Left_loop
A2stepY_A1Leftdone:	

#ifdef SAFE_CONTEXT
	// restore context
	pla: sta tmp5+1: pla: sta tmp5
	pla
#endif // SAFE_CONTEXT

	rts

#endif USE_ASM_AGENTSTEP

#endif //  USE_ASM_BRESFILL


#ifdef USE_ASM_INITSATUR_A1RIGHT
_initSatur_A1Right:
.(
	lda #0
	sta _A1XSatur
	sta _A2XSatur


	;; if (A1X > SCREEN_WIDTH - 1) {
	lda _A1X
	sec
	sbc #SCREEN_WIDTH-1
	bvc *+4
    eor #$80
	bmi initSatur_A1Right_A1Xdone
	bne initSatur_A1Right_A1Xsatur
	;; if (A1sX == 1) {}
	lda _A1sX
	bmi initSatur_A1Right_A1Xdone
initSatur_A1Right_A1Xsatur:
	lda #1 
	sta _A1XSatur
initSatur_A1Right_A1Xdone:


	lda _A2X
#ifndef USE_COLOR
	bmi initSatur_A1Right_A2Xsatur
	bne initSatur_A1Right_A2Xdone
#else
	sec
	sbc #COLUMN_OF_COLOR_ATTRIBUTE
	bvc *+4
    eor #$80
	bmi initSatur_A1Right_A2Xsatur
	bne initSatur_A1Right_A2Xdone
#endif
;; #ifndef USE_COLOR
;;     if (A2X < 0) {
;; #else
;;     if (A2X < COLUMN_OF_COLOR_ATTRIBUTE) {
;; #endif             
;;         A2XSatur = 1;
;;     } 
;; #ifndef USE_COLOR
;;     else if (A2X == 0) {
;;         
;; #else
;;     else if (A2X == COLUMN_OF_COLOR_ATTRIBUTE) {
;; #endif
;;         if (A2sX == 1) {
	lda _A2sX
	bmi initSatur_A1Right_A2Xdone
;;             A2XSatur = 0;
;;         } else {
;;             A2XSatur = 1;
;;         }
;; 
;;     } else {
;;         A2XSatur = 0;
;;     }

initSatur_A1Right_A2Xsatur:
	lda #1 
	sta _A2XSatur

initSatur_A1Right_A2Xdone:
.)
	rts
#endif // USE_ASM_INITSATUR_A1RIGHT

#ifdef USE_ASM_INITSATUR_A1LEFT
_initSatur_A1Left:
.(
	lda #0
	sta _A2XSatur
	sta _A1XSatur

//    if (A2X > SCREEN_WIDTH - 1) {
	lda _A2X
	sec
	sbc #SCREEN_WIDTH-1
	bvc *+4
    eor #$80
	bmi initSatur_A1Left_A2done
	beq initSatur_A1Left_A2OnEdge
	jmp initSatur_A1Left_A2Satur
//        A2XSatur = 1;
//    } else if (A2X == SCREEN_WIDTH - 1) {
//        if (A2sX == 1){
initSatur_A1Left_A2OnEdge:	
	lda _A2sX
	bmi initSatur_A1Left_A2done
//            A2XSatur = 1;
//        } else {
//            A2XSatur = 0;
//        }
//    } else {
//        A2XSatur = 0;
//    }


initSatur_A1Left_A2Satur:
	lda #1 
	sta _A2XSatur

initSatur_A1Left_A2done:




	lda _A1X
#ifndef USE_COLOR
	bmi initSatur_A1Left_A1Satur
	bne initSatur_A1Left_A1done
#else
	sec
	sbc #COLUMN_OF_COLOR_ATTRIBUTE
	bvc *+4
    eor #$80
	bmi initSatur_A1Left_A1Satur
	bne initSatur_A1Left_A1done
#endif
//    #ifndef USE_COLOR
//        if (A1X < 0) {
//    #else
//        if (A1X < COLUMN_OF_COLOR_ATTRIBUTE) {
//    #endif             
//            A1XSatur = 1;
//    #ifndef USE_COLOR
//        } else if (A1X == 0) {
//    #else
//        } else if (A1X == COLUMN_OF_COLOR_ATTRIBUTE) {
//    #endif             
//            if (A1sX == 1){
	lda _A1sX
	bpl initSatur_A1Left_A1done
//                A1XSatur = 0;
//            } else {
//                A1XSatur = 1;
//            }
//        } else {
//            A1XSatur = 0;
//        }

initSatur_A1Left_A1Satur:
	lda #1 
	sta _A1XSatur

initSatur_A1Left_A1done:



.)	
	rts
#endif // USE_ASM_INITSATUR_A1LEFT

#ifdef USE_ASM_SWITCH_A1XSATUR
_switch_A1XSatur:
.(
	lda _A1XSatur
	eor #$01
	sta _A1XSatur
.)
	rts
#endif //USE_ASM_SWITCH_A1XSATUR

#ifdef USE_ASM_SWITCH_A2XSATUR
_switch_A2XSatur:
.(
	lda _A2XSatur
	eor #$01
	sta _A2XSatur
.)
	rts
#endif //USE_ASM_SWITCH_A2XSATUR

#ifdef USE_ASM_BRESTYPE1
_bresStepType1:
.(

    // reachScreen ();
	ldy #0 : jsr _reachScreen :

    // if (A1Right == 0) {
	lda _A1Right
	bne bresStepType1_A1Right
    //     initSatur_A1Left ();
	ldy #0 : jsr _initSatur_A1Left :
    //     hzfill();
	ldy #0 : jsr _hzfill :
    //     while ((A1arrived == 0) && (A1Y > 1)){
	;; jmp bresStepType1_A1Right_endloop
bresStepType1_A1Left_loop:
	lda _A1arrived
	bne bresStepType1_A1Left_endloop
	lda #1
	sec
	sbc _A1Y
	bvc *+4
    eor #$80
	bpl  bresStepType1_A1Left_endloop
    //         A1stepY_A1Left();
		ldy #0 : jsr _A1stepY_A1Left :
    //         A2stepY_A1Left();
		ldy #0 : jsr _A2stepY_A1Left :
    //         hzfill();
		ldy #0 : jsr _hzfill :
		jmp bresStepType1_A1Left_loop
    //     }
bresStepType1_A1Left_endloop:
	jmp bresStepType1_done
bresStepType1_A1Right:
    // } else {
    //     initSatur_A1Right ();
	ldy #0 : jsr _initSatur_A1Right :

    //     hzfill();
	ldy #0 : jsr _hzfill :
	
    //     while ((A1arrived == 0) && (A1Y > 1)){
bresStepType1_A1Right_loop:		
	lda _A1arrived
	bne bresStepType1_A1Right_endloop
	lda #1
	sec
	sbc _A1Y
	bvc *+4
    eor #$80
	bpl  bresStepType1_A1Right_endloop
    //         A1stepY_A1Right();
		ldy #0 : jsr _A1stepY_A1Right :
    //         A2stepY_A1Right();
		ldy #0 : jsr _A2stepY_A1Right :
    //         hzfill();
		ldy #0 : jsr _hzfill :
    //     }
	jmp bresStepType1_A1Right_loop

    // }
bresStepType1_A1Right_endloop:
bresStepType1_done:
.)
	rts
#endif // USE_ASM_BRESTYPE1


#ifdef USE_ASM_BRESTYPE2
_bresStepType2:
.(
    // if (A1Right == 0) {
	lda _A1Right
	bne bresStepType2_A1Right
    //     initSatur_A1Left ();
		ldy #0 : jsr _initSatur_A1Left
    //     while ((A1arrived == 0) && (A2arrived == 0) && (A1Y > 1)) {
bresStepType2_A1Left_loop:
		lda _A1arrived
		bne bresStepType2_A1Left_endloop
		lda _A2arrived
		bne bresStepType2_A1Left_endloop
		lda #1
		sec
		sbc _A1Y
		bvc *+4
		eor #$80
		bpl bresStepType2_A1Left_endloop
    //         A1stepY_A1Left();
		ldy #0 : jsr _A1stepY_A1Left
    //         A2stepY_A1Left();
		ldy #0 : jsr _A2stepY_A1Left
    //         hzfill();
		ldy #0 : jsr _hzfill
		jmp bresStepType2_A1Left_loop
    //     }
bresStepType2_A1Left_endloop:	
	jmp bresStepType2_done
    // } else {
bresStepType2_A1Right:
    //     initSatur_A1Right ();
		ldy #0 : jsr _initSatur_A1Right
    //     while ((A1arrived == 0) && (A2arrived == 0) && (A1Y > 1)){
bresStepType2_A1Right_loop:
		lda _A1arrived
		bne bresStepType2_A1Right_endloop
		lda _A2arrived
		bne bresStepType2_A1Right_endloop
		lda #1
		sec
		sbc _A1Y
		bvc *+4
		eor #$80
		bpl  bresStepType2_A1Right_endloop

    //         A1stepY_A1Right();
		ldy #0 : jsr _A1stepY_A1Right
    //         A2stepY_A1Right();
		ldy #0 : jsr _A2stepY_A1Right
    //         // printf ("hf (%d: %d, %d) = %d %d\n", A1X, A2X, A1Y, distface, ch2disp); get();
    //         // A1Right = (A1X > A2X); 
    //         // printf ("bt2 A1R (%d: %d, %d) = A1XSatur=%d A2XSatur=%d\n", A1X, A2X, A1Y, A1XSatur, A2XSatur); get();
    //         hzfill();
		ldy #0 : jsr _hzfill
		jmp bresStepType2_A1Right_loop
    //     }

bresStepType2_A1Right_endloop:
    // }

bresStepType2_done:
.)
	rts
#endif // USE_ASM_BRESTYPE2


#ifdef USE_ASM_BRESTYPE3
_bresStepType3:
.(
    // reachScreen ();
	ldy #0 : jsr _reachScreen :

    // if (A1Right == 0) {
	lda _A1Right
	bne bresStepType3_A1Right
    //     initSatur_A1Left ();
	ldy #0 : jsr _initSatur_A1Left :
    //     hzfill();
	ldy #0 : jsr _hzfill :
    //     while ((A1arrived == 0) && (A2arrived == 0) && (A1Y > 1) ) {
bresStepType3_A1Left_loop:
	lda _A1arrived
	bne bresStepType3_A1Left_endloop
	lda _A2arrived
	bne bresStepType3_A1Left_endloop
	lda #1
	sec
	sbc _A1Y
	bvc *+4
    eor #$80
	bpl bresStepType3_A1Left_endloop
    //         A1stepY_A1Left();
		ldy #0 : jsr _A1stepY_A1Left
    //         A2stepY_A1Left();
		ldy #0 : jsr _A2stepY_A1Left
    //         hzfill();
		ldy #0 : jsr _hzfill
		jmp bresStepType3_A1Left_loop
    //     }
bresStepType3_A1Left_endloop:
	jmp bresStepType3_done
bresStepType3_A1Right:
    // } else {
    //     initSatur_A1Right ();
	ldy #0 : jsr _initSatur_A1Right
    //     hzfill();
	ldy #0 : jsr _hzfill :
    //     while ((A1arrived == 0) && (A2arrived == 0) && (A1Y > 1) ) {
bresStepType3_A1Right_loop:
	lda _A1arrived
	bne bresStepType3_A1Right_endloop
	lda _A2arrived
	bne bresStepType3_A1Right_endloop
	lda #1
	sec
	sbc _A1Y
	bvc *+4
    eor #$80
	bpl bresStepType3_A1Right_endloop
	
    //         A1stepY_A1Right();
		ldy #0 : jsr _A1stepY_A1Right
    //         A2stepY_A1Right();
		ldy #0 : jsr _A2stepY_A1Right
    //         // printf ("hf (%d: %d, %d) = %d %d\n", A1X, A2X, A1Y, distface, ch2disp); get();
    //         // A1Right = (A1X > A2X); 
    //         hzfill();
		ldy #0 : jsr _hzfill
		jmp bresStepType3_A1Right_loop
    //     }
bresStepType3_A1Right_endloop:
   // }

bresStepType3_done:
.)
	rts
#endif // USE_ASM_BRESTYPE3






#endif // USE_SATURATION

