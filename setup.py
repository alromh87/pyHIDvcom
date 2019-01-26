#!/usr/bin/env python

"""
setup.py file for HIDvcom SWIG wrapper
"""

from setuptools import setup, Extension

ROOT_DIR='../'
INCLUDE_DIR=ROOT_DIR+'API/'
LIB_DIR=ROOT_DIR+'lib/'

HIDvcom_module = Extension('_HIDvcom', ['HIDvcom.i'], swig_opts=['-c++', '-I'+INCLUDE_DIR],
                      include_dirs=[INCLUDE_DIR, ROOT_DIR+'include/'],
                      library_dirs=[LIB_DIR],
                      libraries=['VCOMExample', 'usb-1.0', 'dl', 'util'],
                      )
setup (name = "pyHIDvcom",
#       use_scm_version=True,
#       setup_requires=['setuptools_scm'],
#       version		= '0.1',
       author		= "Alejandro Romero <alromh87@gmail.com>",
       author_email	= "alromh87@gmail.com",
       description	= """SIWG based Python wrapper for HID BIO SDK""",
#       packages		= ["pyNBIS"],
       ext_modules	= [HIDvcom_module],
       py_modules	= ["HIDvcom"],
       )
