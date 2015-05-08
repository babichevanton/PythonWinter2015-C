#include <Python.h>

int main(int argc, char *argv[]) {
    PyObject *expr[5];
    int i, l, s, e, r;
    char *res;

    if(argc < 4) {
        fprintf(stderr,"Usage: <list lgth> <list element> {<list element>} <start> <end> <repeat>\n\n\
Print list[start:end]*repeat");
        exit(0);
    }
    l = atoi(argv[1]);
    s = atoi(argv[l+2]);
    e = atoi(argv[l+3]);
    r = atoi(argv[l+4]);
    expr[0] = PyList_New(l);
    for (i = 0; i < l; ++i) {
        PyList_SetItem(expr[0], i, PyString_FromString(argv[i+2]));
    }
    expr[1] = PyList_GetSlice(expr[0], s, e);
    expr[2] = PySequence_Repeat(expr[1], r);
    l = PySequence_Length(expr[2]);
    expr[3] = PyString_FromString("");
    for(i = 0; i < l; ++i) {
        PyString_Concat(&expr[3], PyList_GetItem(expr[2], i));
    }
    res = PyString_AsString(expr[3]);
    printf("'%s'\n", res);
    for(i = 0; i < 4; i++) {
        Py_CLEAR(expr[i]);
    }
    return 0;
}
