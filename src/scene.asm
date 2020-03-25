;;  __                             
;; / _\     ___   ___  _ __    ___ 
;; \ \     / __| / _ \| '_ \  / _ \
;; _\ \   | (__ |  __/| | | ||  __/
;; \__/    \___| \___||_| |_| \___|
.include "config.inc" 

.export _nbSegments, _nbParticules, _nbFaces
.export _segmentsPt1, _segmentsPt2, _segmentsChar
.export _particulesPt, _particulesChar
.export _facesPt1, _facesPt2, _facesPt3, _facesChar


_nbSegments:         .res 1
_nbParticules:       .res 1
_nbFaces:            .res 1

_segmentsPt1:        .res NB_MAX_SEGMENTS
_segmentsPt2:        .res NB_MAX_SEGMENTS
_segmentsChar:       .res NB_MAX_SEGMENTS

_particulesPt:       .res NB_MAX_PARTICULES
_particulesChar:     .res NB_MAX_PARTICULES


_facesPt1:           .res NB_MAX_FACES
_facesPt2:           .res NB_MAX_FACES
_facesPt3:           .res NB_MAX_FACES
_facesChar:          .res NB_MAX_FACES


