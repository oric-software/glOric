#include "lib.h"

#include "config.h"
#include "glOric.h"

void main() {
#ifdef TEXTMODE
    textDemo();
#endif
#ifdef HRSMODE
    hiresDemo();
#endif
#ifdef LRSMODE
    lrsDemo();
#endif
}
