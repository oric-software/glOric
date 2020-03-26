
.export _d1, _d2, _d3, _dmoy, _idxPt1, _idxPt2, _idxPt3
.export _m1, _m2, _m3, _v1, _v2, _v3, _isFace2BeDrawn
.export _plotX, _plotY

; int           d1, d2, d3;
_d1:         .res 2
_d2:         .res 2
_d3:         .res 2
; int           dmoy;
_dmoy:         .res 2

; unsigned char idxPt1, idxPt2, idxPt3;
_idxPt1:         .res 1
_idxPt2:         .res 1
_idxPt3:         .res 1

;unsigned char isFace2BeDrawn;
_isFace2BeDrawn:  .res 1


; unsigned char m1, m2, m3;
_m1:         .res 1
_m2:         .res 1
_m3:         .res 1
; unsigned char v1, v2, v3;
_v1:         .res 1
_v2:         .res 1
_v3:         .res 1


_plotX:		.res 1
_plotY:		.res 1
