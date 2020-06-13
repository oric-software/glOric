;;    ___                 _              _    _               
;;   / _ \ _ __   ___    (_)  ___   ___ | |_ (_)  ___   _ __  
;;  / /_)/| '__| / _ \   | | / _ \ / __|| __|| | / _ \ | '_ \ 
;; / ___/ | |   | (_) |  | ||  __/| (__ | |_ | || (_) || | | |
;; \/     |_|    \___/  _/ | \___| \___| \__||_| \___/ |_| |_|
;;                     |__/                                   

#ifdef SAVE_ZERO_PAGE
.text
#else
.zero
#endif

;;unsigned char projOptions=0;
_projOptions            .dsb 1

; #ifdef USE_REWORKED_BUFFERS
; ;;unsigned char nbCoords=0;
; _nbCoords           .dsb 1
; #else
;;unsigned char glNbVertices=0;
_glNbVertices               .dsb 1
; #endif


.text

;;char points3d[NB_MAX_VERTICES*SIZEOF_3DPOINT];
;;.dsb 256-(*&255)
;;_points3d       .dsb NB_MAX_VERTICES*SIZEOF_3DPOINT
_points3d:
_glVerticesX          .dsb NB_MAX_VERTICES
_glVerticesY          .dsb NB_MAX_VERTICES
_glVerticesZ          .dsb NB_MAX_VERTICES
#ifndef USE_REWORKED_BUFFERS
_points3unused      .dsb NB_MAX_VERTICES
#endif ;; USE_REWORKED_BUFFERS


;;char points2d [NB_MAX_VERTICES*SIZEOF_2DPOINT];
;;.dsb 256-(*&255)
;;_points2d       .dsb NB_MAX_VERTICES*SIZEOF_2DPOINT


;;char points2d [NB_MAX_COORDS*SIZEOF_2DPOINT];
;;.dsb 256-(*&255)
;;_points2d       .dsb NB_MAX_COORDS*SIZEOF_2DPOINT
_points2d:
_points2aH          .dsb NB_MAX_VERTICES
_points2aV          .dsb NB_MAX_VERTICES
_points2dH          .dsb NB_MAX_VERTICES
_points2dL          .dsb NB_MAX_VERTICES

#include "glProjectArrays.s"
