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
    ; if (P1Y <= P2Y) {
	lda _P2Y: sec: sbc _P1Y : bvc *+4 :	eor #$80
.(
	bpl skip_01
	jmp prepare_bresrun_Lbresfill129
skip_01:.)
	;; lda _P1Y : sta tmp0 :
	;; lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	;; lda _P2Y : sta tmp1 :
	;; lda #0 : ldx tmp1 : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	;; lda tmp1 : cmp tmp0 : lda tmp1+1 : sbc tmp0+1 : .( : bvc *+4 : eor #$80 : bpl skip : jmp prepare_bresrun_Lbresfill129 :skip : .) : : :
    ;     if (P2Y <= P3Y) {
		lda _P3Y: sec: sbc _P2Y : bvc *+4 :	eor #$80 : 
.( 
	bpl skip_01 : jmp prepare_bresrun_Lbresfill131 : 
skip_01:.)
	;; lda _P2Y : sta tmp0 :
	;; lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	;; lda _P3Y : sta tmp1 :
	;; lda #0 : ldx tmp1 : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	;; lda tmp1 : cmp tmp0 : lda tmp1+1 : sbc tmp0+1 : .( : bvc *+4 : eor #$80 : bpl skip : jmp prepare_bresrun_Lbresfill131 :skip : .) : : :
	lda _P3X : sta _pDepX :   ;         pDepX  = P3X;   
	lda _P3Y : sta _pDepY :   ;         pDepY  = P3Y;
	lda _P2X : sta _pArr1X :  ;         pArr1X = P2X;
	lda _P2Y : sta _pArr1Y :  ;         pArr1Y = P2Y;
	lda _P1X : sta _pArr2X :  ;         pArr2X = P1X;
	lda _P1Y : sta _pArr2Y :  ;         pArr2Y = P1Y;
	jmp prepare_bresrun_Lbresfill130 :
    ;     } else {
prepare_bresrun_Lbresfill131
	lda _P2X : sta _pDepX :   ;         pDepX = P2X;
	lda _P2Y : sta _pDepY :   ;         pDepY = P2Y;
    ;         if (P1Y <= P3Y) {
		lda _P3Y: sec: sbc _P1Y : bvc *+4 :	eor #$80
.( : bpl skip_01 : jmp prepare_bresrun_Lbresfill133: skip_01:.)
	;; lda _P1Y : sta tmp0 :
	;; lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	;; lda _P3Y : sta tmp1 :
	;; lda #0 : ldx tmp1 : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	;; lda tmp1 : cmp tmp0 : lda tmp1+1 : sbc tmp0+1 : .( : bvc *+4 : eor #$80 : bpl skip : jmp prepare_bresrun_Lbresfill133 :skip : .) : : :
	lda _P3X : sta _pArr1X :  ;             pArr1X = P3X;
	lda _P3Y : sta _pArr1Y :  ;             pArr1Y = P3Y;
	lda _P1X : sta _pArr2X :  ;             pArr2X = P1X;
	lda _P1Y : sta _pArr2Y :  ;             pArr2Y = P1Y;
	jmp prepare_bresrun_Lbresfill130 :
    ;         } else {
prepare_bresrun_Lbresfill133
	lda _P1X : sta _pArr1X :  ;             pArr1X = P1X;
	lda _P1Y : sta _pArr1Y :  ;             pArr1Y = P1Y;
	lda _P3X : sta _pArr2X :  ;             pArr2X = P3X;
	lda _P3Y : sta _pArr2Y :  ;             pArr2Y = P3Y;
	jmp prepare_bresrun_Lbresfill130 :
    ;         }
    ;     }
    ; } else {
prepare_bresrun_Lbresfill129
    ;     if (P1Y <= P3Y) {
		lda _P3Y: sec: sbc _P1Y : bvc *+4 :	eor #$80
.( : bpl skip_01 : jmp prepare_bresrun_Lbresfill135 : skip_01:.)
	;; lda _P1Y : sta tmp0 :
	;; lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	;; lda _P3Y : sta tmp1 :
	;; lda #0 : ldx tmp1 : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	;; lda tmp1 : cmp tmp0 : lda tmp1+1 : sbc tmp0+1 : .( : bvc *+4 : eor #$80 : bpl skip : jmp prepare_bresrun_Lbresfill135 :skip : .) : : :
	lda _P3X : sta _pDepX  :  ;         pDepX  = P3X;
	lda _P3Y : sta _pDepY  :  ;         pDepY  = P3Y;
	lda _P1X : sta _pArr1X :  ;         pArr1X = P1X;
	lda _P1Y : sta _pArr1Y :  ;         pArr1Y = P1Y;
	lda _P2X : sta _pArr2X :  ;         pArr2X = P2X;
	lda _P2Y : sta _pArr2Y :  ;         pArr2Y = P2Y;
	jmp prepare_bresrun_Lbresfill136 :
    ;     } else {
prepare_bresrun_Lbresfill135
	lda _P1X : sta _pDepX :  ;         pDepX = P1X;
	lda _P1Y : sta _pDepY :  ;         pDepY = P1Y;
    ;         if (P2Y <= P3Y) {
		lda _P3Y: sec: sbc _P2Y : bvc *+4 :	eor #$80
.( : bpl skip_01 : jmp prepare_bresrun_Lbresfill137 : skip_01:.)
	;; lda _P2Y : sta tmp0 :
	;; lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	;; lda _P3Y : sta tmp1 :
	;; lda #0 : ldx tmp1 : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	;; lda tmp1 : cmp tmp0 : lda tmp1+1 : sbc tmp0+1 : .( : bvc *+4 : eor #$80 : bpl skip : jmp prepare_bresrun_Lbresfill137 :skip : .) : : :
	lda _P3X : sta _pArr1X :  ;             pArr1X = P3X;
	lda _P3Y : sta _pArr1Y :  ;             pArr1Y = P3Y;
	lda _P2X : sta _pArr2X :  ;             pArr2X = P2X;
	lda _P2Y : sta _pArr2Y :  ;             pArr2Y = P2Y;
	jmp prepare_bresrun_Lbresfill138 :
    ;         } else {
prepare_bresrun_Lbresfill137
	lda _P2X : sta _pArr1X :  ;             pArr1X = P2X;
	lda _P2Y : sta _pArr1Y :  ;             pArr1Y = P2Y;
	lda _P3X : sta _pArr2X :  ;             pArr2X = P3X;
	lda _P3Y : sta _pArr2Y :  ;             pArr2Y = P3Y;
prepare_bresrun_Lbresfill138
    ;         }
prepare_bresrun_Lbresfill136
    ;     }
prepare_bresrun_Lbresfill130
    ; }
; #ifdef USE_PROFILER
; PROFILE_LEAVE(ROUTINE_PREPAREBRESRUN)
; #endif
.)
	rts :