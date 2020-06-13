
;;    ___                                      
;;   / __\  __ _  _ __ ___    ___  _ __   __ _ 
;;  / /    / _` || '_ ` _ \  / _ \| '__| / _` |
;; / /___ | (_| || | | | | ||  __/| |   | (_| |
;; \____/  \__,_||_| |_| |_| \___||_|    \__,_|


#ifndef TARGET_ORIX                                            
#ifdef SAVE_ZERO_PAGE
.text
#else
.zero
#endif
#else
.text
#endif ;; TARGET_ORIX

 ;; Camera Position
_glCamPosX:		.dsb 1
_glCamPosY:		.dsb 1
_glCamPosZ:		.dsb 1

 ;; Camera Orientation
_glCamRotZ:		.dsb 1			;; -128 -> -127 unit : 2PI/(2^8 - 1)
_glCamRotX:		.dsb 1

.text