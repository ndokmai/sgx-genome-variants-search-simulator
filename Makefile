SGXSDK:=$(abspath deps/sgxsdk)
OPENSSL:=$(abspath deps/openssl)
CURL:=$(abspath deps/curl)
SGXSSL:=$(abspath deps/sgxssl)
SHELL := /bin/bash

all: sgx-genome-variants-search

sgx-genome-variants-search: linux-sgx-sgx_2.3.1 openssl-1.1.0e curl-7.66.0 intel-sgx-ssl-2.2
	git clone https://github.com/ndokmai/sgx-genome-variants-search.git
	cd sgx-genome-variants-search/server; \
	make SGX_MODE=SIM SGX_SDK=$(SGXSDK) \
	    OpenSSL_Path=$(OPENSSL) \
	    Curl_Path=$(CURL) \
	    SGX_SSL_Dir=$(SGXSSL)
	cd sgx-genome-variants-search/service_provider; \
	make SGXSDK_DIR=$(SGXSDK) \
	    OPENSSL_DIR=$(OPENSSL) \
	    CURL_DIR=$(CURL)

linux-sgx-sgx_2.3.1: 
	mkdir -p deps
	wget https://github.com/intel/linux-sgx/archive/sgx_2.3.1.tar.gz --no-check-certificate
	tar xf sgx_2.3.1.tar.gz
	rm -f sgx_2.3.1.tar.gz
	cp autogen-linux.sh linux-sgx-sgx_2.3.1/sdk/cpprt/linux/libunwind/  
	cd linux-sgx-sgx_2.3.1; \
	./download_prebuilt.sh; \
	make; \
	make sdk_install_pkg; \
	(echo "no"; echo "../deps") | ./linux/installer/bin/sgx_linux_x64_sdk_2.3.101.46683.bin

openssl-1.1.0e: 
	mkdir -p $(OPENSSL)
	wget https://www.openssl.org/source/openssl-1.1.0e.tar.gz --no-check-certificate
	tar xf openssl-1.1.0e.tar.gz
	cd openssl-1.1.0e; \
	./config --prefix=$(OPENSSL); \
	make; \
	make install

intel-sgx-ssl-2.2: openssl-1.1.0e 
	wget https://github.com/intel/intel-sgx-ssl/archive/v2.2.tar.gz --no-check-certificate
	tar xf v2.2.tar.gz
	rm -f v2.2.tar.gz
	source deps/sgxsdk/environment; \
	cp openssl-1.1.0e.tar.gz intel-sgx-ssl-2.2/openssl_source/; \
	rm -f openssl-1.1.0e.tar.gz; \
	mkdir -p deps/sgxssl; \
	cd intel-sgx-ssl-2.2/Linux; \
	make all test SGX_MODE=SIM SGX_SDK=$(SGXSDK); \
	make install DESTDIR=$(SGXSSL)

curl-7.66.0: openssl-1.1.0e
	mkdir -p $(CURL)
	wget https://curl.haxx.se/download/curl-7.66.0.tar.gz --no-check-certificate
	tar xf curl-7.66.0.tar.gz
	rm -f curl-7.66.0.tar.gz
	cd curl-7.66.0; \
	env PKG_CONFIG_PATH=$(OPENSSL)/lib/pkgconfig \
	    ./configure --with-ssl --prefix=$(CURL); \
	make; \
	make install

.PHONY: all clean

clean:
	rm -rf linux-sgx-sgx_2.3.1 curl-7.66.0 openssl-1.1.0e intel-sgx-ssl-2.2 sgx-genome-variants-search deps



