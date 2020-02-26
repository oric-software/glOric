;; 8-bits output  Pseudo Random Number Generator
;; based on a 16-bit Galois linear feedback shift register with polynomial $0039.
;; found at https://wiki.nesdev.com/w/index.php/Random_number_generator

;; Typical usage is :
;;
;; initRand(deek(0x276));
;; randValue = getRand();

#include "config.h"
#ifdef USE_RANDOM
_asmSeed .dsb 2

asmRand:
.(
    lda _asmSeed+1
	tay ; store copy of high byte
	; compute _asmSeed+1 ($39>>1 = %11100)
	lsr ; shift to consume zeroes on left...
	lsr
	lsr
	sta _asmSeed+1 ; now recreate the remaining bits in reverse order... %111
	lsr
	eor _asmSeed+1
	lsr
	eor _asmSeed+1
	eor _asmSeed+0 ; recombine with original low byte
	sta _asmSeed+1
	; compute _asmSeed+0 ($39 = %111001)
	tya ; original high byte
	sta _asmSeed+0
	asl
	eor _asmSeed+0
	asl
	eor _asmSeed+0
	asl
	asl
	asl
	eor _asmSeed+0
	sta _asmSeed+0
.)
    rts

;; C Binding

;; void initRand(unsigned int seed);
_initRand:
.(
	; ldx #6 : lda #0 : jsr enter :
    pha: tay: pha
	ldy #0 : lda (sp),y : sta _asmSeed : iny : lda (sp),y : sta _asmSeed+1 :
	; jmp leave :
    pla: tay: pla
.)
    rts

;; unsigned char getRand(void);
_getRand:
.(
    pha: tay: pha
    jsr asmRand
    tax
    pla: tay: pla
.)
    rts


#endif // USE_RANDOM