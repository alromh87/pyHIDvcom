#!/usr/bin/env python
# -*- coding: utf-8 -*-
import HIDvcom
import sys

from PIL import Image

try:
  import nfiq
except ImportError:
  nfiq_available = False
  print 'NFIQ not available install from: https://github.com/alromh87/NBIS-python'
else:
  nfiq_available = True

#No utilizar, regresa 1 aunque no hay dispositivos -> HIDvcom.V100_Get_Num_USB_Devices() 
resultadoComando, dispositivos = HIDvcom.V100_Get_Num_USB_Devices()
print 'Detectar dispositvos:\n\tResultado:', resultadoComando, '\n\tDetectados:', dispositivos
pDev = {}

rc = HIDvcom.V100_Open(pDev);
if rc != 0:
  print 'No se pudo abrir el lector, error:', rc
  sys.exit()
print '\nDispositivo:'
for llave, valor in pDev.items():
  print "\t%s ->\t%d"% (llave, valor)

rc, conf = HIDvcom.V100_Get_Config(pDev);
if rc != 0:
  print 'No se pudo obtener configuración, error:', rc
  sys.exit()
print '\nConfiguración:'
for llave, valor in conf.items():
  print "\t%s ->\t%d"% (llave, valor)

tamano = {'nWidth': conf['Composite_Image_Size_X'], 'nHeight': conf['Composite_Image_Size_Y']}

getComposite = 1
getTemplate  = 1
rc, width, height, composite, template, spoof = HIDvcom.V100_Capture(pDev, tamano, getComposite, getTemplate)
if rc != 0:
  print 'Error al solicitar huella:', rc
  sys.exit()

img = Image.frombuffer('L', [width, height], composite, "raw", 'L', 0, 1)
img.show()

print '\nHuella obtenida: \n\tSpoof:', spoof
if nfiq_available:
  result =  nfiq.comp_nfiq(composite,  width,  height, 8, 500)
  print '\tCalidad:', result[1]

with open("huella.raw", 'wb') as raw_file:
  raw_file.write(composite)
  print "\nHuella en bruto guardada en: huella.raw"  
with open("huella.temp", 'wb') as raw_file:
  raw_file.write(template)
  print "\nPlantilla de huella guardada en: huella.temp"  
