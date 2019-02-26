Quick & Dirty basic wrapper to use HID_Bio_SDK_6.01.26 from python.

#### Just basic functions implemented:

- [x] Start device
- [x] Get config (TODO: return full)
- [x] Capture composite image
- [x] Capture template image

#### Installation

Install requiered packages:
```
sudo apt-get install build-essentials g++ libusb-1.0-0-dev
```

Clone inside HID_Bio_SDK_6.01.26 -> Linux_6.01.26 -> VCOM-Integration-Kit_v6.01.26 -> VCOMExample and execute:
```
make
sudo make install
```

##### Note:
If make fails with error: invalidad conversion from 'char' to 'char*', edit Makefiles to include -fpermissive when invoking g++
- VCOMExample/Makefile
- VCOMExampleApp/Makefile

TODO: find better fix!!

#### Extras
You can get fingerprint quality score from NIST's NFIQ by installing NBIS for python from https://github.com/alromh87/NBIS-python
