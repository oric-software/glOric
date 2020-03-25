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

//unsigned char projOptions=0;
_projOptions            .dsb 1

; #ifdef USE_REWORKED_BUFFERS
; //unsigned char nbCoords=0;
; _nbCoords           .dsb 1
; #else
//unsigned char nbPoints=0;
_nbPoints               .dsb 1
; #endif


.text

//char points3d[NB_MAX_POINTS*SIZEOF_3DPOINT];
//.dsb 256-(*&255)
//_points3d       .dsb NB_MAX_POINTS*SIZEOF_3DPOINT
_points3d:
_points3dX          .dsb NB_MAX_POINTS
_points3dY          .dsb NB_MAX_POINTS
_points3dZ          .dsb NB_MAX_POINTS
#ifndef USE_REWORKED_BUFFERS
_points3unused      .dsb NB_MAX_POINTS
#endif // USE_REWORKED_BUFFERS


//char points2d [NB_MAX_POINTS*SIZEOF_2DPOINT];
//.dsb 256-(*&255)
//_points2d       .dsb NB_MAX_POINTS*SIZEOF_2DPOINT


//char points2d [NB_MAX_COORDS*SIZEOF_2DPOINT];
//.dsb 256-(*&255)
//_points2d       .dsb NB_MAX_COORDS*SIZEOF_2DPOINT
_points2d:
_points2aH          .dsb NB_MAX_POINTS
_points2aV          .dsb NB_MAX_POINTS
_points2dH          .dsb NB_MAX_POINTS
_points2dL          .dsb NB_MAX_POINTS


#ifdef USE_ASM_ARRAYSPROJECT
_glProjectArrays:
.(
    // for (ii = 0; ii < nbPoints; ii++){
	ldy		_nbPoints
glProjectArrays_loop:
	dey
	bmi		glProjectArrays_done
		//     x = points3dX[ii];
		lda 	_points3dX, y
		sta		_PointX
		//     y = points3dY[ii];
		lda 	_points3dY, y
		sta		_PointY
		//     z = points3dZ[ii];
		lda 	_points3dZ, y
		sta		_PointZ

    //     projectPoint(x, y, z, options, &ah, &av, &dist);
		jsr 	_project_i8o8 :

    //     points2aH[ii] = ah;
		lda 	_ResX
		sta		_points2aH, y
    //     points2aV[ii] = av;
		lda 	_ResY
		sta		_points2aV, y
    //     points2dH[ii] = (signed char)((dist & 0xFF00)>>8) && 0x00FF;
		lda		_Norm+1
		sta		_points2dH, y
    //     points2dL[ii] = (signed char) (dist & 0x00FF);
		lda		_Norm
		sta		_points2dL, y

    // }
	jmp glProjectArrays_loop
glProjectArrays_done:
.)
	rts
#endif // USE_ASM_ARRAYSPROJECT


