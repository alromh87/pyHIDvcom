all:	HIDvcom
	python setup.py build
HIDvcom:
	cd ../; make;

install: all
	python setup.py install --record installedFiles.txt
	cp ../lib/libVCOMExample.so /usr/lib/

uninstall:
	cat installedFiles.txt | xargs rm -rf
	rm /usr/lib/libVCOMExample.so

clean:
	rm -r *.cpp *.so *.pyc dist build *.egg-info/
#//	rm *.py // este no!!!

