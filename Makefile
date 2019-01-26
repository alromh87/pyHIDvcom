all:	HIDvcom
	python setup.py build
HIDvcom:
	cd ../; make;

install: all
	python setup.py install
	cp ../lib/libVCOMExample.so /usr/lib/

clean:
	rm -r *.cpp *.so *.pyc dist build *.egg-info/
#//	rm *.py // este no!!!

