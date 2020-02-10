#include "lib.h"

#include "config.h"
#include "glOric.h"

void main() {
#ifdef TEXTDEMO
    textDemo();
#endif
#ifdef HRSDEMO
    hiresDemo();
#endif
#ifdef LRSDEMO
    lrsDemo();
#endif
}
