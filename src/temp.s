

#ifdef SAVE_ZERO_PAGE
.text
#else
.zero
#endif

; int           d1, d2, d3;
_d1         .dsb 2
_d2         .dsb 2
_d3         .dsb 2
; int           dmoy;
_dmoy         .dsb 2

; unsigned char idxPt1, idxPt2, idxPt3;
_idxPt1         .dsb 1
_idxPt2         .dsb 1
_idxPt3         .dsb 1

;unsigned char isFace2BeDrawn;
_isFace2BeDrawn  .dsb 1


; unsigned char m1, m2, m3;
_m1         .dsb 1
_m2         .dsb 1
_m3         .dsb 1
; unsigned char v1, v2, v3;
_v1         .dsb 1
_v2         .dsb 1
_v3         .dsb 1


_plotX		.dsb 1
_plotY		.dsb 1

.text