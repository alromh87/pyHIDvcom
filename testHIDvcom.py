#!/usr/bin/env python
# -*- coding: utf-8 -*-
import HIDvcom
import sys
import nfiq

from PIL import Image

#No utilizar, regresa 1 aunque no hay dispositivos -> HIDvcom.V100_Get_Num_USB_Devices() 
resultadoComando, dispositivos = HIDvcom.V100_Get_Num_USB_Devices()
print 'Detectar dispositvos:\n\tResultado:', resultadoComando, '\n\tDetectados:', dispositivos
pDev = {}

rc, pDev = HIDvcom.V100_Open(pDev);
if rc != 0:
  print 'No se pudo abrir el lector, error:', rc
  sys.exit()
print '\nDispositivo:', pDev

rc, pDev = HIDvcom.V100_Get_Config(pDev);
if rc != 0:
  print 'No se pudo obtener configuración, error:', rc
  sys.exit()
print 'Conf Ok'

print 'Solicitando Huella'
getComposite = 1
getTemplate  = 1
rc, pDev, width, height, composite, template, spoof = HIDvcom.V100_Capture(pDev, getComposite, getTemplate)
if rc != 0:
  print 'Error al solicitar huella:', rc
  sys.exit()


img = Image.frombuffer('L', [width, height], composite, "raw", 'L', 0, 1)
img.show()

result =  nfiq.comp_nfiq(composite,  width,  height, 8, 8)
print 'Huella obtenida-> \n\tSpoof:', spoof, '\n\tCalidad:', result[1]

with open("huella.raw", 'wb') as raw_file:
    raw_file.write(composite)
with open("huella.temp", 'wb') as raw_file:
    raw_file.write(template)
