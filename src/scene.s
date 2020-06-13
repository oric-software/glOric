;;  __                             
;; / _\     ___   ___  _ __    ___ 
;; \ \     / __| / _ \| '_ \  / _ \
;; _\ \   | (__ |  __/| | | ||  __/
;; \__/    \___| \___||_| |_| \___|
                                
#ifndef TARGET_ORIX
#ifdef SAVE_ZERO_PAGE
.text
#else
.zero
#endif ;; SAVE_ZERO_PAGE
#else
.text
#endif ;; TARGET_ORIX

;;unsigned char nbSegments=0;
_nbSegments     .dsb 1
;;unsigned char nbParticles=0;
_nbParticles .dsb 1;
;;unsigned char nbFaces=0;
_nbFaces .dsb 1;

.text

;;char segments[NB_MAX_SEGMENTS*SIZEOF_SEGMENT];
; .dsb 256-(*&255)
; _segments       .dsb NB_MAX_SEGMENTS*SIZEOF_SEGMENT
_segments:
_segmentsPt1        .dsb NB_MAX_SEGMENTS
_segmentsPt2        .dsb NB_MAX_SEGMENTS
_segmentsChar       .dsb NB_MAX_SEGMENTS


;;char particles[NB_MAX_SEGMENTS*SIZEOF_PARTICLE];
; _particles       .dsb NB_MAX_PARTICLES*SIZEOF_PARTICLE
_particles:
_particlesPt       .dsb NB_MAX_PARTICLES
_particlesChar     .dsb NB_MAX_PARTICLES



; _faces       .dsb NB_MAX_FACES*SIZEOF_FACE
_faces:
_facesPt1           .dsb NB_MAX_FACES
_facesPt2           .dsb NB_MAX_FACES
_facesPt3           .dsb NB_MAX_FACES
_facesChar          .dsb NB_MAX_FACES


