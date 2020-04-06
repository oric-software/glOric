#ifdef USE_ASM_ISA1RIGHT1


#ifdef TARGET_ORIX
; tmp6 .dsb 2
; tmp7 .dsb 2
#endif

// void isA1Right1 ()
_isA1Right1:
.(
#ifdef SAFE_CONTEXT
	// save context
    pha:txa:pha:tya:pha
	lda tmp7 : pha
	lda tmp7+1 : pha
	lda tmp6 : pha
	lda tmp6+1 : pha
#endif // SAFE_CONTEXT
    // if ((mDeltaX1 & 0x80) == 0){
	lda #$00 : sta _A1Right
	lda _mDeltaX1
	bmi isA1Right1_mDeltaX1_negativ:
        
    // 	  if ((mDeltaX2 & 0x80) == 0){
		lda _mDeltaX2
		bmi isA1Right1_mDeltaX2_negativ_01
    //         // printf ("%d*%d  %d*%d ", mDeltaY1, mDeltaX2, mDeltaY2,mDeltaX1);get ();
    //         A1Right = (log2_tab[mDeltaX2] + log2_tab[mDeltaY1]) > (log2_tab[mDeltaX1] + log2_tab[mDeltaY2]);
    //         // A1Right = mDeltaY1*mDeltaX2 > mDeltaY2*mDeltaX1;

			ldx _mDeltaY1
			ldy _mDeltaX2
			clc
			lda _log2_tab,x
			adc _log2_tab,y
			ror						; to avoid modulo by overflow
			sta tmp7

			ldx _mDeltaX1			; abs(mDeltaX1)
			ldy _mDeltaY2
			clc
			lda _log2_tab,x
			adc _log2_tab,y
			ror						; to avoid modulo by overflow
			sta tmp7+1			; (log2_tab[abs(mDeltaX1)] + log2_tab[mDeltaY2])

			cmp tmp7

			bcs isA1Right1_done

			lda #$01 : sta _A1Right

			jmp isA1Right1_done
isA1Right1_mDeltaX2_negativ_01:
    //     } else {
			lda #$00 : sta _A1Right
    //         A1Right = 0 ; // (mDeltaX1 < 0) 
    //     }
	jmp isA1Right1_done
isA1Right1_mDeltaX1_negativ:
    // } else {
		eor #$ff: sec: adc #$00: sta tmp6 ; tmp6 = abs(mDeltaX1)
 
    //     if ((mDeltaX2 & 0x80) == 0){
		lda _mDeltaX2
		bmi isA1Right1_mDeltaX2_negativ_02
    //         A1Right = 1 ; // (mDeltaX1 < 0)
			lda #$01 : sta _A1Right
			jmp isA1Right1_done
 isA1Right1_mDeltaX2_negativ_02;
    //     } else {
    //         // printf ("%d*%d  %d*%d ", mDeltaY1, -mDeltaX2, mDeltaY2,-mDeltaX1);get ();
			eor #$ff: sec: adc #$00: sta tmp6+1 ; tmp6+1 = abs(mDeltaX2)
    //         A1Right = (log2_tab[abs(mDeltaX2)] + log2_tab[mDeltaY1]) < (log2_tab[abs(mDeltaX1)] + log2_tab[mDeltaY2]);

			ldx tmp6+1			; abs(mDeltaX2)
			ldy _mDeltaY1
			clc
			lda _log2_tab,x
			adc _log2_tab,y
			ror					; to avoid modulo by overflow
			sta tmp7			; log2_tab[abs(mDeltaX2)] + log2_tab[mDeltaY1]

			ldx tmp6			; abs(mDeltaX1)
			ldy _mDeltaY2
			clc
			lda _log2_tab,x
			adc _log2_tab,y
			ror					; to avoid modulo by overflow
			sta tmp7+1			; (log2_tab[abs(mDeltaX1)] + log2_tab[mDeltaY2])

			cmp tmp7 

			bcc isA1Right1_done

			lda #$01 : sta _A1Right

    //     }
    // }

isA1Right1_done:
#ifdef SAFE_CONTEXT
	// restore context
	pla : sta tmp6+1 : 
	pla : sta tmp6 : 
	pla : sta tmp7+1 : 
	pla : sta tmp7 : 
	pla:tay:pla:tax:pla
#endif // SAFE_CONTEXT
.)
	rts
#endif // USE_ASM_ISA1RIGHT1

#ifdef USE_ASM_ISA1RIGHT3
// void isA1Right3 ()
_isA1Right3:
.(
	lda #$00 : sta _A1Right

	// A1Right = (A1X > A2X);
	lda _A2X
	sec
	sbc _A1X
	bvc *+4
	eor #$80
	bpl isA1Right3_done

	lda #$01 : sta _A1Right
isA1Right3_done:
.)
	rts
#endif // USE_ASM_ISA1RIGHT3