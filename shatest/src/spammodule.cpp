#include <Python.h>
#include <stdlib.h>
#include <string>
#include <iostream>

int sha1_file(const std::string& filename, std::string& checksum, bool binary);

static PyObject *
spam_system(PyObject *self, PyObject *args)
{
    const char *command;
    int sts;

    if (!PyArg_ParseTuple(args, "s", &command))
        return NULL;
    sts = system(command);
    return Py_BuildValue("i", sts);
}

static PyObject *
spam_sha1_file(PyObject *self, PyObject *args)
{
    const char *filename;
    int sts;

    if (!PyArg_ParseTuple(args, "s", &filename))
        return NULL;
    
    std::string cs;
    sts = sha1_file(filename, cs, false);
    std::cout << cs << "  " << filename << std::endl;
    return Py_BuildValue("i", sts);
}

static PyMethodDef SpamMethods[] =
{
     {"system", spam_system, METH_VARARGS, "Greet somebody."},
     {"sha1_file", spam_sha1_file, METH_VARARGS, "Calculate SHA1 checksum for a file."},
     {NULL, NULL, 0, NULL}
};

PyMODINIT_FUNC
initspam(void)
{
     (void) Py_InitModule("spam", SpamMethods);
}
