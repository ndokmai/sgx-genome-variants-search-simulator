FROM ubuntu:18.04 

WORKDIR /workspace
COPY . /workspace

RUN apt-get update
RUN apt-get -y install build-essential ocaml ocamlbuild automake autoconf libtool \
        wget python libssl-dev libcurl4-openssl-dev protobuf-compiler libprotobuf-dev \
        debhelper git

RUN make
RUN rm -rf linux-sgx-sgx_2.3.1 curl-7.66.0 openssl-1.1.0e intel-sgx-ssl-2.2 \
       v2.2.tar.gz sgx_2.3.1.tar.gz curl-7.66.0.tar.gz openssl-1.1.0e.tar.gz

CMD ["/bin/bash"]
