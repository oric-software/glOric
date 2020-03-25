;;    ___                 _              _    _               
;;   / _ \ _ __   ___    (_)  ___   ___ | |_ (_)  ___   _ __  
;;  / /_)/| '__| / _ \   | | / _ \ / __|| __|| | / _ \ | '_ \ 
;; / ___/ | |   | (_) |  | ||  __/| (__ | |_ | || (_) || | | |
;; \/     |_|    \___/  _/ | \___| \___| \__||_| \___/ |_| |_|
;;                     |__/                                   
.include "config.inc"

.export _projOptions, _nbPoints
.export _points3dX, _points3dY, _points3dZ, _points2aH, _points2aV, _points2dH, _points2dL


_projOptions:        .res 1
_nbPoints:           .res 1

_points3dX:          .res NB_MAX_POINTS
_points3dY:          .res NB_MAX_POINTS
_points3dZ:          .res NB_MAX_POINTS

_points2aH:          .res NB_MAX_POINTS
_points2aV:          .res NB_MAX_POINTS
_points2dH:          .res NB_MAX_POINTS
_points2dL:          .res NB_MAX_POINTS


