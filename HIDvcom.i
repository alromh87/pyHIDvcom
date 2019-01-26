/* vcom.i */
%module HIDvcom

%{
#include "VCOMCore.h"
%}

%apply int * OUTPUT { int * };
%apply int & OUTPUT { int & };

//%apply int* {unsigned int*};
//%apply char* {unsigned char*};

%typemap(in) unsigned char* = char*;

%typemap(out) V100_ERROR_CODE = int;

%typemap(in) V100_DEVICE_TRANSPORT_INFO *{ /* Assign dictionary vars to struct*/
  V100_DEVICE_TRANSPORT_INFO Dev;

  PyObject * llaveDeviceNumber	= PyString_FromString("DeviceNumber");
  PyObject * llavehRead		= PyString_FromString("DeviceNumber");
  PyObject * llavehWrite	= PyString_FromString("DeviceNumber");
  PyObject * llavenCOMIndex	= PyString_FromString("DeviceNumber");
  PyObject * llavenBaudRate	= PyString_FromString("DeviceNumber");
  PyObject * llavehInstance	= PyString_FromString("hInstance");

  Dev.DeviceNumber = PyDict_Contains($input, llaveDeviceNumber) ? (unsigned int)PyInt_AS_LONG(PyDict_GetItem($input,llaveDeviceNumber)) : 0;
  Dev.nCOMIndex    = PyDict_Contains($input, llavenCOMIndex) ? (unsigned int)PyInt_AS_LONG(PyDict_GetItem($input,llavenCOMIndex)) : 0;
  Dev.nBaudRate    = PyDict_Contains($input, llavenBaudRate) ? (unsigned int)PyInt_AS_LONG(PyDict_GetItem($input,llavenBaudRate)) : 0;
  Dev.hRead	   = PyDict_Contains($input, llavehRead) ? PyLong_AsVoidPtr(PyDict_GetItem($input,llavehRead)) : 0;
  Dev.hWrite	   = PyDict_Contains($input, llavehWrite) ? PyLong_AsVoidPtr(PyDict_GetItem($input,llavehWrite)) : 0;
  Dev.hInstance	   = PyDict_Contains($input, llavehInstance) ? PyLong_AsVoidPtr(PyDict_GetItem($input,llavehInstance)) : 0;

  $1 = &Dev;
}

%typemap(argout) V100_DEVICE_TRANSPORT_INFO* (PyObject* o) %{
  o = PyDict_New();
  PyDict_SetItem(o, PyString_FromString("DeviceNumber"),	PyInt_FromLong($1->DeviceNumber)); //TODO:care long cast
  PyDict_SetItem(o, PyString_FromString("hRead"),		PyLong_FromVoidPtr($1->hRead));
  PyDict_SetItem(o, PyString_FromString("hWrite"),		PyLong_FromVoidPtr($1->hWrite));
  PyDict_SetItem(o, PyString_FromString("nComIndex"),		PyInt_FromLong($1->nCOMIndex)); //TODO:care long cast
  PyDict_SetItem(o, PyString_FromString("nBaudRate"),		PyInt_FromLong($1->nBaudRate)); //TODO:care long cast
  PyDict_SetItem(o, PyString_FromString("hInstance"),		PyLong_FromVoidPtr($1->hInstance));
  $result = SWIG_Python_AppendOutput($result,o);
%}

%typemap(in,numinputs=0) _V100_INTERFACE_CONFIGURATION_TYPE * (_V100_INTERFACE_CONFIGURATION_TYPE config){
  $1 = &config;
}
//%typemap(argout) V100_INTERFACE_CONFIGURATION_TYPE * (PyObject* o)%{
/*TODO: setup config return*/

//%}
//uchar* pTemplate,  uint&  nTemplateSize,

%typemap(in,numinputs=0) (uchar* pCompositeImage, uint&  nWidth, uint&  nHeight)(uchar* pCompositeImage, uint nWidth, uint nHeight){
  nWidth=272;
  nHeight=400;
  pCompositeImage = new uchar[nWidth*nHeight];

  $1 = pCompositeImage;
  $2 = &nWidth;
  $3 = &nHeight;
}

%typemap(argout) (uchar* pCompositeImage, uint&  nWidth, uint&  nHeight){
  $result = SWIG_Python_AppendOutput(resultobj, SWIG_From_int((*$2)));
  $result = SWIG_Python_AppendOutput(resultobj, SWIG_From_int((*$3)));
  $result = SWIG_Python_AppendOutput(resultobj, PyString_FromStringAndSize((const char*)($1), (*$2)*(*$3)));
}

%typemap(in,numinputs=0) (uchar* pTemplate, uint& nTemplateSize)(uchar pTemplate[2048], uint nTemplateSize){
  $1 = pTemplate;
  $2 = &nTemplateSize;
}
%typemap(argout) (uchar* pTemplate, uint& nTemplateSize){
  $result = SWIG_Python_AppendOutput(resultobj, PyString_FromStringAndSize((const char*)($1), *$2));
}

%include "VCOMCore.h"
