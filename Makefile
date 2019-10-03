SGXSDK:=$(abspath deps/sgxsdk)
OPENSSL:=$(abspath deps/openssl)
CURL:=$(abspath deps/curl)
SGXSSL:=$(abspath deps/sgxssl)
SHELL:=/bin/bash
PROJECT_DIR?=sgx-genome-variants-search

all: 
	cd $(PROJECT_DIR)/server && \
	make SGX_MODE=SIM SGX_SDK=$(SGXSDK) \
	    OpenSSL_Path=$(OPENSSL) \
	    Curl_Path=$(CURL) \
	    SGX_SSL_Dir=$(SGXSSL)
	cd $(PROJECT_DIR)/service_provider && \
	make SGXSDK_DIR=$(SGXSDK) \
	    OPENSSL_DIR=$(OPENSSL) \
	    CURL_DIR=$(CURL)

.PHONY: all clean 

clean:
	make clean -C $(PROJECT_DIR)/server
	make clean -C $(PROJECT_DIR)/service_provider

	


