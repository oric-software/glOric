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

;;unsigned char glNbSegments=0;
_glNbSegments     .dsb 1
;;unsigned char glNbParticles=0;
_glNbParticles .dsb 1;
;;unsigned char glNbFaces=0;
_glNbFaces .dsb 1;

.text

;;char segments[NB_MAX_SEGMENTS*SIZEOF_SEGMENT];
; .dsb 256-(*&255)
; _segments       .dsb NB_MAX_SEGMENTS*SIZEOF_SEGMENT
_segments:
_glSegmentsPt1        .dsb NB_MAX_SEGMENTS
_glSegmentsPt2        .dsb NB_MAX_SEGMENTS
_glSegmentsChar       .dsb NB_MAX_SEGMENTS


;;char particles[NB_MAX_SEGMENTS*SIZEOF_PARTICLE];
; _particles       .dsb NB_MAX_PARTICLES*SIZEOF_PARTICLE
_particles:
_glParticlesPt       .dsb NB_MAX_PARTICLES
_glParticlesChar     .dsb NB_MAX_PARTICLES



; _faces       .dsb NB_MAX_FACES*SIZEOF_FACE
_faces:
_glFacesPt1           .dsb NB_MAX_FACES
_glFacesPt2           .dsb NB_MAX_FACES
_glFacesPt3           .dsb NB_MAX_FACES
_glFacesChar          .dsb NB_MAX_FACES


