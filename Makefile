SGXSDK:=$(abspath deps/sgxsdk)
OPENSSL:=$(abspath deps/openssl)
CURL:=$(abspath deps/curl)
SGXSSL:=$(abspath deps/sgxssl)
SHELL:=/bin/bash

all: sgx-genome-variants-search

sgx-genome-variants-search: linux-sgx-sgx_2.3.1 openssl-1.1.0e curl-7.66.0 intel-sgx-ssl-2.2
	git clone https://github.com/ndokmai/sgx-genome-variants-search.git
	source environment && \
	cd sgx-genome-variants-search/server && \
	make SGX_MODE=SIM SGX_SDK=$(SGXSDK) \
	    OpenSSL_Path=$(OPENSSL) \
	    Curl_Path=$(CURL) \
	    SGX_SSL_Dir=$(SGXSSL)
	cd sgx-genome-variants-search/service_provider && \
	make SGXSDK_DIR=$(SGXSDK) \
	    OPENSSL_DIR=$(OPENSSL) \
	    CURL_DIR=$(CURL)

linux-sgx-sgx_2.3.1:
	mkdir -p deps
	wget -nc https://github.com/intel/linux-sgx/archive/sgx_2.3.1.tar.gz
	tar xf sgx_2.3.1.tar.gz --no-overwrite-dir 
	cd linux-sgx-sgx_2.3.1 && \
	./download_prebuilt.sh && \
	make && \
	make sdk_install_pkg && \
	(echo "no"; echo "../deps") | ./linux/installer/bin/sgx_linux_x64_sdk_2.3.101.46683.bin

openssl-1.1.0e: 
	mkdir -p $(OPENSSL)
	wget -nc https://www.openssl.org/source/openssl-1.1.0e.tar.gz
	tar xf openssl-1.1.0e.tar.gz --no-overwrite-dir 
	cd openssl-1.1.0e && \
	./config --prefix=$(OPENSSL) && \
	make && \
	make install

curl-7.66.0: openssl-1.1.0e
	mkdir -p $(CURL)
	wget -nc https://curl.haxx.se/download/curl-7.66.0.tar.gz
	tar xf curl-7.66.0.tar.gz --no-overwrite-dir 
	cd curl-7.66.0 && \
	./configure --with-ssl=$(OPENSSL) --prefix=$(CURL) && \
	make && \
	make install

intel-sgx-ssl-2.2: openssl-1.1.0e linux-sgx-sgx_2.3.1
	mkdir -p $(SGXSSL)
	wget -nc https://github.com/intel/intel-sgx-ssl/archive/v2.2.tar.gz
	tar xf v2.2.tar.gz --no-overwrite-dir 
	cp openssl-1.1.0e.tar.gz intel-sgx-ssl-2.2/openssl_source
	source $(SGXSDK)/environment && \
	cd intel-sgx-ssl-2.2/Linux && \
	make all test SGX_MODE=SIM SGX_SDK=$(SGXSDK) && \
	make install DESTDIR=$(SGXSSL)


.PHONY: all clean

clean:
	rm -rf linux-sgx-sgx_2.3.1 curl-7.66.0 openssl-1.1.0e intel-sgx-ssl-2.2 sgx-genome-variants-search deps \
	    v2.2.tar.gz sgx_2.3.1.tar.gz curl-7.66.0.tar.gz openssl-1.1.0e.tar.gz



