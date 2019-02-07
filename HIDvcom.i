/* vcom.i */
%module HIDvcom

%{
#include "VCOMCore.h"
%}

%apply int * OUTPUT { int * };
%apply int & OUTPUT { int & };

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

%typemap(argout) V100_DEVICE_TRANSPORT_INFO* %{
  PyDict_SetItem($input, PyString_FromString("DeviceNumber"),	PyInt_FromLong($1->DeviceNumber)); //TODO: Take care of unsigned int -> long cast
  PyDict_SetItem($input, PyString_FromString("hRead"),		PyLong_FromVoidPtr($1->hRead));
  PyDict_SetItem($input, PyString_FromString("hWrite"),		PyLong_FromVoidPtr($1->hWrite));
  PyDict_SetItem($input, PyString_FromString("nComIndex"),	PyInt_FromLong($1->nCOMIndex)); //TODO: Take care of unsigned int -> long cast
  PyDict_SetItem($input, PyString_FromString("nBaudRate"),	PyInt_FromLong($1->nBaudRate)); //TODO: Take care of unsigned int -> long cast
  PyDict_SetItem($input, PyString_FromString("hInstance"),	PyLong_FromVoidPtr($1->hInstance));
%}

%typemap(in,numinputs=0) _V100_INTERFACE_CONFIGURATION_TYPE * (_V100_INTERFACE_CONFIGURATION_TYPE config){
  $1 = &config;
}
%typemap(argout) _V100_INTERFACE_CONFIGURATION_TYPE * (PyObject* o) %{
  o = PyDict_New();
  //TODO: Take care of unsigned short -> long cast
  PyDict_SetItem(o, PyString_FromString("Vendor_Id"),			PyInt_FromLong($1->Vendor_Id));
  PyDict_SetItem(o, PyString_FromString("Product_Id"),			PyInt_FromLong($1->Product_Id));
  PyDict_SetItem(o, PyString_FromString("Device_Serial_Number"),	PyInt_FromLong($1->Device_Serial_Number));
  PyDict_SetItem(o, PyString_FromString("Device_Serial_Number_Ex"),	PyInt_FromLong($1->Device_Serial_Number_Ex));
  PyDict_SetItem(o, PyString_FromString("MfgStateFlag"),		PyInt_FromLong($1->MfgStateFlag));
/*
        Hardware_Rev,                           // HW Revision Number                   (xxx.xxx.xxx)
        Firmware_Rev,                           // FW Revision Number                   (xxx.xxx.xxx)
        Spoof_Rev,                                      // Spoof Revision Number                (xxx.xxx.xxx)
        PreProc_Rev,                            // PreProcessor Revision Number (xxx.xxx.xxx)
        Feature_Extractor_Rev,          // Feature Extractor Revision Number (xxx.xxx.xxx)
        Matcher_Rev,                            // Matcher Revision Number              (xxx.xxx.xxx)
        ID_Rev,                                         // Identifier Revision Number   (xxx.xxx.xxx)
        Imager_Chip_Version,            // Imager Chip Silicon Version
        Number_Image_Planes,            // Number of Image Planes in Native Image Stack
*/
  PyDict_SetItem(o, PyString_FromString("Native_Image_Size_X"),		PyInt_FromLong($1->Native_Image_Size_X));
  PyDict_SetItem(o, PyString_FromString("Native_Image_Size_Y"),		PyInt_FromLong($1->Native_Image_Size_Y));
  PyDict_SetItem(o, PyString_FromString("Native_DPI"),			PyInt_FromLong($1->Native_DPI));
  PyDict_SetItem(o, PyString_FromString("Composite_Image_Size_X"),	PyInt_FromLong($1->Composite_Image_Size_X));
  PyDict_SetItem(o, PyString_FromString("Composite_Image_Size_Y"),	PyInt_FromLong($1->Composite_Image_Size_Y));
  PyDict_SetItem(o, PyString_FromString("Composite_DPI"),		PyInt_FromLong($1->Composite_DPI));
//  PyDict_SetItem(o, PyString_FromString(""),		PyInt_FromLong($1->));
/*
        Image_Format,                           // Format of Native Images (_V100_IMAGE_FORMAT_TYPE)
        Boresight_X,                            // Pixel Units wrt Native Coords
        Boresight_Y,                            // Pixel Units wrt Native Coords
        LED_Wavelength1,                        // Nanometers (State Ordered)
        LED_Wavelength2,                        // Nanometers (State Ordered)
        LED_Wavelength3,                        // Nanometers (State Ordered)
        LED_Wavelength4,                        // Nanometers (State Ordered)
        LED_Type1,                                      // (_V100_LED_TYPE)
        LED_Type2,                                      // (_V100_LED_TYPE)
        LED_Type3,                                      // (_V100_LED_TYPE)
        LED_Type4,                                      // (_V100_LED_TYPE)
        State1_Exposure,                        // Current Exp Value from Last Image Acquisition
        State2_Exposure,
        State3_Exposure,
        State4_Exposure,
        State1_Dark_Exposure,           // Current Exp Value from Dark Frame Acquisition
        State2_Dark_Exposure,
        State3_Dark_Exposure,
        State4_Dark_Exposure,
        Phy_Interface_Available,        // Physical Interfaces Available (_V100_PHY_INTERFACE_TYPE)
        PreProc_Available,                      // PreProcessors Available (_V100_PREPROC_TYPE)
        Feature_Extract_Available,      // Feature Extractors Available (_V100_FE_TYPE)
        Template_Match_Available,       // Template Matchers Available (_V100_FM_TYPE)
        Template_Format_Available,      // Template Formats Available _V100_TEMPLATE_FORMAT_TYPE)
        Template_ID_Available,          // Template Identification Available ( _V100_ID_TYPE)
        Presence_Detect_Available,      // Presence Detection Available (_V100_PRESENCE_DETECTION_TYPE)
        FW_Flash_Available,                     // In-circuit Flash Capability Available (_V100_FLASH_TYPE)
        Spoof_Available,                        // Spoof Algorithms Available (_V100_SPOOF_TYPE)
        Struct_Size;                            // Size in Bytes of This Structure

*/

  //TODO:Take care of unsigned int -> long cast
  PyDict_SetItem(o, PyString_FromString("pImageBuffer"),	PyInt_FromLong($1->pImageBuffer));
  PyDict_SetItem(o, PyString_FromString("pPDBuffer"),		PyInt_FromLong($1->pPDBuffer));
  PyDict_SetItem(o, PyString_FromString("pStaticMask"),		PyInt_FromLong($1->pStaticMask));
  PyDict_SetItem(o, PyString_FromString("pDarkBuffer"),		PyInt_FromLong($1->pDarkBuffer));
  PyDict_SetItem(o, PyString_FromString("pCompositeBuffer"),	PyInt_FromLong($1->pCompositeBuffer));

  $result = SWIG_Python_AppendOutput($result,o);
%}

%typemap(in,numinputs=1) (uchar* pCompositeImage, uint&  nWidth, uint&  nHeight)(uchar* pCompositeImage, uint nWidth, uint nHeight){
  PyObject * llavenWidth	= PyString_FromString("nWidth");
  PyObject * llavenHeight	= PyString_FromString("nHeight");

  nWidth	= PyDict_Contains($input, llavenWidth)  ? (unsigned int)PyInt_AS_LONG(PyDict_GetItem($input,llavenWidth))  : 272;
  nHeight	= PyDict_Contains($input, llavenHeight) ? (unsigned int)PyInt_AS_LONG(PyDict_GetItem($input,llavenHeight)) : 400;

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
