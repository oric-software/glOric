#ifndef LRSDRAWING_H
#define LRSDRAWING_H
extern void change_char(char c, unsigned char patt01, unsigned char patt02, unsigned char patt03, unsigned char patt04, unsigned char patt05, unsigned char patt06, unsigned char patt07, unsigned char patt08);
#ifdef USE_REWORKED_BUFFERS
extern void glDrawFaces();
extern void glDrawSegments();
extern void glDrawParticles();
#else
extern void lrDrawFaces(char points2d[], unsigned char faces[], unsigned char glNbFaces);
extern void lrDrawSegments(char points2d[], unsigned char segments[], unsigned char glNbSegments);
extern void lrDrawParticles(char points2d[], unsigned char particles[], unsigned char glNbParticles);

#endif // USE_REWORKED_BUFFERS
#endif // LRSDRAWING_H