#include "config.h"
#ifdef USE_PROFILER
#include "profile.h"
#endif

.zero

lineIndex   .dsb 1
departX     .dsb 1
finX        .dsb 1
hLineLength .dsb 1

.text




// void hzfill() {
_hzfill:
.(
; #ifdef USE_PROFILER
; PROFILE_ENTER(ROUTINE_HZFILL)
; #endif
	// save context
    pha:txa:pha:tya:pha

	lda tmp0: pha
	lda tmp0+1: pha
	lda tmp1: pha
	lda tmp1+1: pha

//     if ((A1Y <= 0) || (A1Y >= SCREEN_HEIGHT)) return;
	lda _A1Y				; Access Y coordinate
;     bpl *+5
;     jmp hzfill_done
; #ifdef USE_COLOR
;     cmp #SCREEN_HEIGHT-NB_LESS_LINES_4_COLOR
; #else
;     cmp #SCREEN_HEIGHT
; #endif
;     bcc *+5
; 	jmp hzfill_done
    sta lineIndex ; A1Y

//     if (A1X > A2X) {
	; lda _A1X				
	; sec
	; sbc _A2X				; signed cmp to p2x
	; bvc *+4
	; eor #$80
	; bmi hzfill_A2xOverOrEqualA1x
	lda _A1Right ; (A1X > A2X)
	beq hzfill_A2xOverOrEqualA1x


#ifdef // USE_SATURATION

		lda _A2XSatur
		beq hzfill_A2XDontSatur_01 
#ifdef USE_COLOR		
		lda #COLUMN_OF_COLOR_ATTRIBUTE
#else
		lda #0
#endif
		jmp hzfill_A2xPositiv
hzfill_A2XDontSatur_01:
		lda _A2X		

#else // not USE_SATURATION	

#ifdef USE_COLOR
//		dx = max(2, A2X);
		lda _A2X
		sec
		sbc #COLUMN_OF_COLOR_ATTRIBUTE
		bvc *+4
		eor #$80
		bmi hzfill_A2xLowerThan3
		lda _A2X
		jmp hzfill_A2xPositiv
hzfill_A2xLowerThan3:
		lda #COLUMN_OF_COLOR_ATTRIBUTE
#else
//      dx = max(0, A2X);
		lda _A2X
		bpl hzfill_A2xPositiv
		lda #0
#endif // USE_COLOR

#endif // USE_SATURATION

hzfill_A2xPositiv:
		sta departX ; dx



//         fx = min(A1X, SCREEN_WIDTH - 1);
#ifdef USE_SATURATION
		lda _A1XSatur
		beq hzfill_A1XDontSatur
			lda #SCREEN_WIDTH - 1
			sta finX
			jmp hzfill_computeNbPoints
hzfill_A1XDontSatur:
			lda _A1X
			sta finX
			jmp hzfill_computeNbPoints


#else // USE_SATURATION
		lda _A1X
		sta finX
		sec
		sbc #SCREEN_WIDTH - 1
		bvc *+4
		eor #$80
		bmi hzfill_A1xOverScreenWidth
		lda #SCREEN_WIDTH - 1
		sta finX
hzfill_A1xOverScreenWidth:
		jmp hzfill_computeNbPoints

#endif // USE_SATURATION

hzfill_A2xOverOrEqualA1x:
//     } else {

#ifdef USE_SATURATION	

		lda _A1XSatur
		beq hzfill_A1XDontSatur_02
#ifdef USE_COLOR		
		lda #COLUMN_OF_COLOR_ATTRIBUTE
#else
		lda #0
#endif
		jmp hzfill_A1xPositiv
hzfill_A1XDontSatur_02:
		lda _A1X

#else // not USE_SATURATION

#ifdef USE_COLOR
//		dx = max(2, A1X);
		lda _A1X
		sec
		sbc #COLUMN_OF_COLOR_ATTRIBUTE
		bvc *+4
		eor #$80
		bmi hzfill_A1xLowerThan3
		lda _A1X
		jmp hzfill_A1xPositiv
hzfill_A1xLowerThan3:
		lda #COLUMN_OF_COLOR_ATTRIBUTE
#else
//      dx = max(0, A1X);
		lda _A1X
		bpl hzfill_A1xPositiv
		lda #0
#endif

#endif // USE_SATURATION


hzfill_A1xPositiv:
		sta departX

//         fx = min(A2X, SCREEN_WIDTH - 1);

#ifdef  USE_SATURATION
		lda _A2XSatur
		beq hzfill_A2XDontSatur_02		
			lda #SCREEN_WIDTH - 1
			sta finX
		jmp hzfill_computeNbPoints
hzfill_A2XDontSatur_02:
		lda _A2X	
		sta finX	

#else // USE_SATURATION
		lda _A2X ; p2x
		sta finX
		sec
		sbc #SCREEN_WIDTH - 1
		bvc *+4
		eor $80
		bmi hzfill_A2xOverScreenWidth
		lda #SCREEN_WIDTH - 1
		sta finX
hzfill_A2xOverScreenWidth:
#endif // USE_SATURATION

//     }
hzfill_computeNbPoints:
//     nbpoints = fx - dx;
//     if (nbpoints < 0) return;
	sec
	lda finX
	sbc departX
    beq hzfill_done
	bmi hzfill_done
	sta hLineLength

//     // printf ("dx=%d py=%d nbpoints=%d dist= %d, char2disp= %d\n", dx, py, nbpoints,  dist, char2disp);get();

// #ifdef USE_ZBUFFER
//     zline(dx, A1Y, nbpoints, distface, ch2disp);
	; clc
	; lda sp
	; sta tmp3
	; adc #10
	; sta sp
	; lda sp+1
	; sta tmp3+1
	; adc #0
	; sta sp+1
	; lda tmp0 : ldy #0 : sta (sp),y ;; dx
	; lda reg2 : ldy #2 : sta (sp),y ;; py
	; lda tmp2 : ldy #4 : sta (sp),y ;; nbpoints
	; lda _distface : ldy #6 : sta (sp),y ;; dist
	; lda _ch2disp : ldy #8 : sta (sp),y ;; char2disp


    
	// ldy #10 : jsr _zline

    ldx lineIndex ; A1Y

    // ptrZbuf = zbuffer + py * SCREEN_WIDTH + dx;
 	lda ZBufferAdressLow,x	; Get the LOW part of the zbuffer adress
	clc						
	adc departX				; Add dx coordinate
	sta tmp1                ; ptrZbuf
	lda ZBufferAdressHigh,x	; Get the HIGH part of the zbuffer adress
	adc #0					; 
	sta tmp1+1	 ; ptrZbuf+ 1			

    // ptrFbuf = fbuffer + py * SCREEN_WIDTH + dx;
    lda FBufferAdressLow,x	; Get the LOW part of the fbuffer adress
    clc						; 
    adc departX				; Add dx coordinate
    sta tmp0                ; ptrFbuf
    lda FBufferAdressHigh,x	; Get the HIGH part of the fbuffer adress
    adc #0					; 
    sta tmp0+1	            ; ptrFbuf+ 1			

   // ptrFbuf = fbuffer + offset;

    // while (nbp > 0) {
    ldy hLineLength
_hzline_loop: 

    //     if (dist < ptrZbuf[nbp]) {
    lda (tmp1), y
    cmp _distface
    bcc hzline_distOver
    //         ptrFbuf[nbp] = char2disp;
    lda _ch2disp
    sta (tmp0), y
    //         ptrZbuf[nbp] = dist;
    lda _distface
    sta (tmp1), y
   //     }
hzline_distOver:
    //     nbp--;
    dey
    bne _hzline_loop
    // }





// #else
//     // TODO : draw a line whit no z-buffer
// #endif


hzfill_done:
	// restore context

	pla: sta tmp1+1
	pla: sta tmp1
 	pla: sta tmp0+1
	pla: sta tmp0
 
	pla:tay:pla:tax:pla
// }
; #ifdef USE_PROFILER
; PROFILE_LEAVE(ROUTINE_HZFILL)
; #endif
.)
	rts
