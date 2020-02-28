#include "config.h"

    ;; if (abs(P2AH) < abs(P1AH)) {
    ;;     tmpH = P1AH;
    ;;     tmpV = P1AV;
    ;;     P1AH = P2AH;
    ;;     P1AV = P2AV;
    ;;     P2AH = tmpH;
    ;;     P2AV = tmpV;
    ;; }
    ;; if (abs(P3AH) < abs(P1AH)) {
    ;;     tmpH = P1AH;
    ;;     tmpV = P1AV;
    ;;     P1AH = P3AH;
    ;;     P1AV = P3AV;
    ;;     P3AH = tmpH;
    ;;     P3AV = tmpV;
    ;; }
    ;; if (abs(P3AH) < abs(P2AH)) {
    ;;     tmpH = P2AH;
    ;;     tmpV = P2AV;
    ;;     P2AH = P3AH;
    ;;     P2AV = P3AV;
    ;;     P3AH = tmpH;
    ;;     P3AV = tmpV;
    ;; }

#ifdef USE_ASM_SORTPOINTS
_sortPoints:
.(
	; ldx #6 : lda #6 : jsr enter :

	// save context
    pha
	lda reg0:pha
	lda tmp0:pha ; tmpH
	lda tmp1:pha ; tmpV


    ;; if (abs(P2AH) < abs(P1AH)) {
.(
	lda _P1AH
	bpl positiv_02
	eor #$FF
	clc
	adc #1
positiv_02:
	sta reg0

	lda _P2AH
	bpl positiv_01
	eor #$FF
	clc
	adc #1
positiv_01:

	cmp reg0
	bcs sortPoints_step01
.)
    ;;     tmpH = P1AH;
    ;;     tmpV = P1AV;
    ;;     P1AH = P2AH;
    ;;     P1AV = P2AV;
    ;;     P2AH = tmpH;
    ;;     P2AV = tmpV;
	lda _P1AH : sta tmp0 :
	lda _P1AV : sta tmp1 :
	lda _P2AH : sta _P1AH :
	lda _P2AV : sta _P1AV :
	lda tmp0 : sta _P2AH :
	lda tmp1 : sta _P2AV :


    ;; }
sortPoints_step01:	
    ;; if (abs(P3AH) < abs(P1AH)) {
.(
	lda _P1AH
	bpl positiv_02
	eor #$FF
	clc
	adc #1
positiv_02:
	sta reg0

	lda _P3AH
	bpl positiv_01
	eor #$FF
	clc
	adc #1
positiv_01:

	cmp reg0
	bcs sortPoints_step02
.)
    ;;     tmpH = P1AH;
    ;;     tmpV = P1AV;
    ;;     P1AH = P3AH;
    ;;     P1AV = P3AV;
    ;;     P3AH = tmpH;
    ;;     P3AV = tmpV;
	lda _P1AH : sta tmp0 :
	lda _P1AV : sta tmp1 :
	lda _P3AH : sta _P1AH :
	lda _P3AV : sta _P1AV :
	lda tmp0 : sta _P3AH :
	lda tmp1 : sta _P3AV :
    ;; }
sortPoints_step02:	
    ;; if (abs(P3AH) < abs(P2AH)) {
.(
	lda _P2AH
	bpl positiv_02
	eor #$FF
	clc
	adc #1
positiv_02:
	sta reg0

	lda _P3AH
	bpl positiv_01
	eor #$FF
	clc
	adc #1
positiv_01:

	cmp reg0
	bcs sortPoints_done
.)
    ;;     tmpH = P2AH;
    ;;     tmpV = P2AV;
    ;;     P2AH = P3AH;
    ;;     P2AV = P3AV;
    ;;     P3AH = tmpH;
    ;;     P3AV = tmpV;
	lda _P2AH : sta tmp0 :
	lda _P2AV : sta tmp1 :
	lda _P3AH : sta _P2AH :
	lda _P3AV : sta _P2AV :
	lda tmp0 : sta _P3AH :
	lda tmp1 :sta _P3AV :

    ;; }

sortPoints_done:	

	// restore context
	pla: sta tmp1
	pla: sta tmp0
	pla: sta reg0
	pla


	; jmp leave :
.)
	rts
#endif // USE_ASM_SORTPOINTS

#ifdef USE_ASM_GUESSIFFACE2BEDRAWN
_guessIfFace2BeDrawn:
.(
	; ldx #10 : lda #8 : jsr enter :

	// save context
    pha
	lda reg0:pha
	lda reg1:pha
	lda tmp0:pha
	lda tmp1:pha

    // m1 = P1AH & ANGLE_MAX;
	lda _P1AH
	and #ASM_ANGLE_MAX
	sta _m1
    // m2 = P2AH & ANGLE_MAX;
	lda _P2AH
	and #ASM_ANGLE_MAX
	sta _m2
    // m3 = P3AH & ANGLE_MAX;
	lda _P3AH
	and #ASM_ANGLE_MAX
	sta _m3
    // v1 = P1AH & ANGLE_VIEW;
	lda _P1AH
	and #ASM_ANGLE_VIEW
	sta _v1
    // v2 = P2AH & ANGLE_VIEW;
	lda _P2AH
	and #ASM_ANGLE_VIEW
	sta _v2
    // v3 = P3AH & ANGLE_VIEW;
	lda _P3AH
	and #ASM_ANGLE_VIEW
	sta _v3

    // isFace2BeDrawn = 0;
	lda #0
	sta _isFace2BeDrawn
debug_ici:
    // if ((m1 == 0x00) || (m1 == ANGLE_MAX)) {
	lda _m1
	beq guessIfFace2BeDrawn_m1extrema
	cmp #ASM_ANGLE_MAX
	beq guessIfFace2BeDrawn_m1extrema
	jmp guessIfFace2BeDrawn_p1back
guessIfFace2BeDrawn_m1extrema:
    //     if ((v1 == 0x00) || (v1 == ANGLE_VIEW)) {
			lda _v1 
			beq guessIfFace2BeDrawn_p1view
			cmp #ASM_ANGLE_VIEW
			beq guessIfFace2BeDrawn_p1view
			jmp guessIfFace2BeDrawn_p1face
guessIfFace2BeDrawn_p1view:
    //         if (
    //             (
    //                 (P1AH & 0x80) != (P2AH & 0x80)) ||
    //             ((P1AH & 0x80) != (P3AH & 0x80))) {
					lda _P1AH 
					eor _P2AH
					and #$80
					bne guessIfFace2BeDrawn_midscreencrossed
					lda _P1AH 
					eor _P3AH
					and #$80
					bne guessIfFace2BeDrawn_midscreencrossed

					jmp guessIfFace2BeDrawn_p1face
guessIfFace2BeDrawn_midscreencrossed:
    //             if ((abs(P3AH) < 127 - abs(P1AH))) {
					.(		
						lda _P1AH
						bpl positiv_01
						eor #$FF
						clc
						adc #1
					positiv_01:
						sta reg0			; reg 0 <- abs(P1AH)

						lda _P3AH
						bpl positiv_02
						eor #$FF
						clc
						adc #1
					positiv_02:
						clc
						adc reg0			; a  <- abs(P3AH) + abs(P1AH)
						bpl guessIfFace2BeDrawn_found01 ; FIXME if sign bit is set <= 127 considtion rather than < 127

					.)
						jmp guessIfFace2BeDrawn_done
    //                 isFace2BeDrawn=1;
guessIfFace2BeDrawn_found01:
							lda #1
							sta _isFace2BeDrawn
							jmp guessIfFace2BeDrawn_done
    //             }
guessIfFace2BeDrawn_p1face:
    //         } else {
    //             isFace2BeDrawn=1;
					lda #1
					sta _isFace2BeDrawn
					jmp guessIfFace2BeDrawn_done
    //         }
guessIfFace2BeDrawn_p1front:	
    //     } else {
    //         // P1 FRONT
    //         if ((m2 == 0x00) || (m2 == ANGLE_MAX)) {
				lda _m2
				beq guessIfFace2BeDrawn_p2front
				cmp #ASM_ANGLE_MAX
				beq guessIfFace2BeDrawn_p2front
				jmp guessIfFace2BeDrawn_p2back
    //             // P2 FRONT
guessIfFace2BeDrawn_p2front:
    //             if ((m3 == 0x00) || (m3 == ANGLE_MAX)) {
					lda _m3
					beq guessIfFace2BeDrawn_p3front
					cmp #ASM_ANGLE_MAX
					beq guessIfFace2BeDrawn_p3front
					jmp guessIfFace2BeDrawn_p3back
guessIfFace2BeDrawn_p3front:
    //                 // P3 FRONT
    //                 // _4_
    //                 if (((P1AH & 0x80) != (P2AH & 0x80)) 
	//						|| ((P1AH & 0x80) != (P3AH & 0x80))) {
						lda _P1AH 
						eor _P2AH
						and #$80
						bne guessIfFace2BeDrawn_midscreencrossed_02
						lda _P1AH 
						eor _P3AH
						and #$80
						bne guessIfFace2BeDrawn_midscreencrossed_02

						jmp guessIfFace2BeDrawn_done
guessIfFace2BeDrawn_midscreencrossed_02:						
    //                     isFace2BeDrawn=1;
							lda #1
							sta _isFace2BeDrawn
							jmp guessIfFace2BeDrawn_done
    //                 } else {
    //                     // nothing to do
    //                 }
guessIfFace2BeDrawn_p3back:
    //             } else {
    //                 // P3 BACK
    //                 // _3_
    //                 if ((P1AH & 0x80) != (P2AH & 0x80)) {
						lda _P1AH 
						eor _P2AH
						and #$80
						beq guessIfFace2BeDrawn_midscreencrossed_03
				
    //                     if (abs(P2AH) < 127 - abs(P1AH)) {
						.(		
							lda _P1AH
							bpl positiv_01
							eor #$FF
							clc
							adc #1
						positiv_01:
							sta reg0			; reg 0 <- abs(P1AH)

							lda _P2AH
							bpl positiv_02
							eor #$FF
							clc
							adc #1
						positiv_02:
							clc
							adc reg0			; a  <- abs(P2AH) + abs(P1AH)
							bpl guessIfFace2BeDrawn_found02 ; FIXME if sign bit is set <= 127 considtion rather than < 127

						.)
							jmp guessIfFace2BeDrawn_midscreencrossed_04
guessIfFace2BeDrawn_found02:
    //                         isFace2BeDrawn=1;
								lda #1
								sta _isFace2BeDrawn
								jmp guessIfFace2BeDrawn_done
    //                     }
guessIfFace2BeDrawn_midscreencrossed_03:
    //                 } else {
    //                     if ((P1AH & 0x80) != (P3AH & 0x80)) {
							lda _P1AH 
							eor _P3AH
							and #$80
							beq guessIfFace2BeDrawn_midscreencrossed_04
    //                         if (abs(P3AH) < 127 - abs(P1AH)) {
							.(		
								lda _P1AH
								bpl positiv_01
								eor #$FF
								clc
								adc #1
							positiv_01:
								sta reg0			; reg 0 <- abs(P1AH)

								lda _P3AH
								bpl positiv_02
								eor #$FF
								clc
								adc #1
							positiv_02:
								clc
								adc reg0			; a  <- abs(P3AH) + abs(P1AH)
								bpl guessIfFace2BeDrawn_found03 ; FIXME if sign bit is set <= 127 considtion rather than < 127

							.)
								jmp guessIfFace2BeDrawn_midscreencrossed_04
guessIfFace2BeDrawn_found03:
    //                             isFace2BeDrawn=1;
									lda #1
									sta _isFace2BeDrawn
									jmp guessIfFace2BeDrawn_done
    //                         }
    //                     }
    //                 }
guessIfFace2BeDrawn_midscreencrossed_04:
    //                 if ((P1AH & 0x80) != (P3AH & 0x80)) {
						lda _P1AH 
						eor _P3AH
						and #$80
						bne guessIfFace2BeDrawn_tmp01
						jmp guessIfFace2BeDrawn_done
    //                     if (abs(P3AH) < 127 - abs(P1AH)) {
guessIfFace2BeDrawn_tmp01:
						.(		
							lda _P1AH
							bpl positiv_01
							eor #$FF
							clc
							adc #1
						positiv_01:
							sta reg0			; reg 0 <- abs(P1AH)

							lda _P3AH
							bpl positiv_02
							eor #$FF
							clc
							adc #1
						positiv_02:
							clc
							adc reg0			; a  <- abs(P3AH) + abs(P1AH)
							bpl guessIfFace2BeDrawn_found04 ; FIXME if sign bit is set <= 127 considtion rather than < 127

						.)		
							jmp guessIfFace2BeDrawn_done
guessIfFace2BeDrawn_found04:
    //                         isFace2BeDrawn=1;
								lda #1
								sta _isFace2BeDrawn
								jmp guessIfFace2BeDrawn_done
    //                     }
    //                 }
    //             }
guessIfFace2BeDrawn_p2back:
    //         } else {
    //             // P2 BACK
    //             if ((P1AH & 0x80) != (P2AH & 0x80)) {
					lda _P1AH 
					eor _P2AH
					and #$80
					beq guessIfFace2BeDrawn_midscreencrossed_05
    //                 if (abs(P2AH) < 127 - abs(P1AH)) {
					.(		
						lda _P1AH
						bpl positiv_01
						eor #$FF
						clc
						adc #1
					positiv_01:
						sta reg0			; reg 0 <- abs(P1AH)

						lda _P3AH
						bpl positiv_02
						eor #$FF
						clc
						adc #1
					positiv_02:
						clc
						adc reg0			; a  <- abs(P3AH) + abs(P1AH)
						bpl guessIfFace2BeDrawn_found05 ; FIXME if sign bit is set <= 127 considtion rather than < 127

					.)	
						jmp guessIfFace2BeDrawn_midscreencrossed_06
guessIfFace2BeDrawn_found05:
    //                     isFace2BeDrawn=1;
							lda #1
							sta _isFace2BeDrawn
							jmp guessIfFace2BeDrawn_done
    //                 }
guessIfFace2BeDrawn_midscreencrossed_05:
    //             } else {
    //                 if ((P1AH & 0x80) != (P3AH & 0x80)) {
						lda _P1AH 
						eor _P3AH
						and #$80
						beq guessIfFace2BeDrawn_midscreencrossed_06
    //                     if (abs(P3AH) < 127 - abs(P1AH)) {
						.(		
							lda _P1AH
							bpl positiv_01
							eor #$FF
							clc
							adc #1
						positiv_01:
							sta reg0			; reg 0 <- abs(P1AH)

							lda _P3AH
							bpl positiv_02
							eor #$FF
							clc
							adc #1
						positiv_02:
							clc
							adc reg0			; a  <- abs(P3AH) + abs(P1AH)
							bpl guessIfFace2BeDrawn_found06 ; FIXME if sign bit is set <= 127 considtion rather than < 127

						.)	
							jmp guessIfFace2BeDrawn_midscreencrossed_06
guessIfFace2BeDrawn_found06:
    //                         isFace2BeDrawn=1;
								lda #1
								sta _isFace2BeDrawn
								jmp guessIfFace2BeDrawn_done
    //                     }
    //                 }
    //             }
guessIfFace2BeDrawn_midscreencrossed_06:
    //             if ((P1AH & 0x80) != (P3AH & 0x80)) {
					lda _P1AH 
					eor _P3AH
					and #$80
					beq guessIfFace2BeDrawn_done
    //                 if (abs(P3AH) < 127 - abs(P1AH)) {
						.(		
							lda _P1AH
							bpl positiv_01
							eor #$FF
							clc
							adc #1
						positiv_01:
							sta reg0			; reg 0 <- abs(P1AH)

							lda _P3AH
							bpl positiv_02
							eor #$FF
							clc
							adc #1
						positiv_02:
							clc
							adc reg0			; a  <- abs(P3AH) + abs(P1AH)
							bmi guessIfFace2BeDrawn_done ; FIXME if sign bit is set <= 127 considtion rather than < 127

						.)
    //                     isFace2BeDrawn=1;
								lda #1
								sta _isFace2BeDrawn
								jmp guessIfFace2BeDrawn_done
    //                 }
    //             }
    //         }
    //     }
guessIfFace2BeDrawn_p1back:
    // } else {
    //     // P1 BACK
    //     // _1_ nothing to do
    // }

guessIfFace2BeDrawn_done:

	// restore context
	pla: sta tmp1
	pla: sta tmp0
	pla: sta reg1
	pla: sta reg0
	pla

	; jmp leave :

.)
    rts
#endif