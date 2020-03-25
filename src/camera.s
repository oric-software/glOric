
;;    ___                                      
;;   / __\  __ _  _ __ ___    ___  _ __   __ _ 
;;  / /    / _` || '_ ` _ \  / _ \| '__| / _` |
;; / /___ | (_| || | | | | ||  __/| |   | (_| |
;; \____/  \__,_||_| |_| |_| \___||_|    \__,_|
                                            
#ifdef SAVE_ZERO_PAGE
.text
#else
.zero
#endif

 // Camera Position
_CamPosX:		.dsb 2
_CamPosY:		.dsb 2
_CamPosZ:		.dsb 2

 // Camera Orientation
_CamRotZ:		.dsb 1			// -128 -> -127 unit : 2PI/(2^8 - 1)
_CamRotX:		.dsb 1
