#ifndef LRSDRAWING_H
#define LRSDRAWING_H
extern void change_char(char c, unsigned char patt01, unsigned char patt02, unsigned char patt03, unsigned char patt04, unsigned char patt05, unsigned char patt06, unsigned char patt07, unsigned char patt08);
#ifdef USE_REWORKED_BUFFERS
extern void glDrawFaces();
extern void glDrawSegments();
extern void glDrawParticules();
#else
extern void lrDrawFaces(char points2d[], unsigned char faces[], unsigned char nbFaces);
extern void lrDrawSegments(char points2d[], unsigned char segments[], unsigned char nbSegments);
extern void lrDrawParticules(char points2d[], unsigned char particules[], unsigned char nbParticules);

#endif // USE_REWORKED_BUFFERS
#endif // LRSDRAWING_H