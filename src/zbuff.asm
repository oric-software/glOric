

.export		_fbuffer
.export		_zbuffer

.segment	"BSS"

_fbuffer:
	.res	1040,$00
_zbuffer:
	.res	1040,$00