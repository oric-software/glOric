.include "config.inc"
.export _A1X       
.export _A1Y	    
.export _A1destX	
.export _A1destY	
.export _A1dX   	
.export _A1dY   	
.export _A1err  	
.export _A1sX  	
.export _A1sY   	
.export _A1arrived	
.export _A2X    	
.export _A2Y       
.export _A2destX   
.export _A2destY   
.export _A2dX      
.export _A2dY      
.export _A2err     
.export _A2sX      
.export _A2sY      
.export _A2arrived 

.export _A1Right
.export _mDeltaY1
.export _mDeltaX1
.export _mDeltaY2
.export _mDeltaX2

.export _P1X
.export _P1Y
.export _P2X
.export _P2Y
.export _P3X
.export _P3Y
.export _P1AH
.export _P1AV
.export _P2AH
.export _P2AV
.export _P3AH
.export _P3AV
.export _pDepX
.export _pDepY
.export _pArr1X
.export _pArr1Y
.export _pArr2X
.export _pArr2Y
.export _distface
.export _distseg
.export _ch2disp

.IFDEF USE_SATURATION
.export _A1XSatur
.export _A2XSatur
.ENDIF

.IFDEF USE_SATURATION
_A1XSatur: .res 1
_A2XSatur: .res 1
.ENDIF

_A1X:        .res 1
_A1Y:	    .res 1
_A1destX:	.res 1
_A1destY:	.res 1
_A1dX:   	.res 1
_A1dY:   	.res 1
_A1err:  	.res 1
_A1sX:  	.res 1
_A1sY:   	.res 1
_A1arrived:	.res 1
_A2X:    	.res 1
_A2Y:        .res 1
_A2destX:    .res 1
_A2destY:    .res 1
_A2dX:       .res 1
_A2dY:       .res 1
_A2err:      .res 1
_A2sX:       .res 1
_A2sY:       .res 1
_A2arrived:  .res 1

_A1Right:    .res 1

_mDeltaY1: .res  1
_mDeltaX1: .res  1
_mDeltaY2: .res  1
_mDeltaX2: .res  1


_P1X: .res 1
_P1Y: .res 1
_P2X: .res 1
_P2Y: .res 1
_P3X: .res 1
_P3Y: .res 1

_P1AH: .res 1
_P1AV: .res 1
_P2AH: .res 1
_P2AV: .res 1
_P3AH: .res 1
_P3AV: .res 1


_pDepX:  .res 1
_pDepY:  .res 1
_pArr1X: .res 1
_pArr1Y: .res 1
_pArr2X: .res 1
_pArr2Y: .res 1

_distface:   .res 1
_distseg:    .res 1
_ch2disp:    .res 1
