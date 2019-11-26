#第一阶段，创建一个ubuntu的容器，里面安装gcc编译工具，并下载源码编译
#对不同的架构需要安装相应的gcc工具链，这里演示x86平台
FROM ubuntu:14.04 as builder

# Install deps
RUN apt-get -q update \
		&& apt-get install -y 	git python python-dev build-essential wget ca-certificates \
			libncurses5-dev automake libtool bison flex texinfo gawk curl cvs subversion gcj-jdk libexpat1-dev gperf --no-install-recommends \
		&& apt-get clean \
		&& rm -rf /var/lib/apt/lists/*

# Set ENV VARs
ENV CROSSTOOL_DIR /opt/crosstool-ng-1.17.0
ENV TOOLCHAIN_DIR /opt/toolchain

# Install Crosstool-NG 1.17.0
RUN	wget http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-1.17.0.tar.bz2 \
	&& tar -xjvf crosstool-ng-1.17.0.tar.bz2 \
	&& rm -f crosstool-ng-1.17.0.tar.bz2 \
	&& cd crosstool-ng-1.17.0 \
	&& ./configure --prefix=$CROSSTOOL_DIR \
	&& make \
	&& make install \
	&& cd ..

ENV PATH $PATH:$CROSSTOOL_DIR/bin

# Create toolchain
RUN sleep 5
RUN whereis  arm-armv7hf-linux-gnueabi-gcc
RUN cd /
RUN find  -name "*arm-armv7hf-linux-gnueabi-gcc*" > $CROSSTOOL_DIR/find.log
RUN sleep 5
COPY . /
#RUN sed -i -e "s@^CT_PREFIX_DIR.*@CT_PREFIX_DIR="$TOOLCHAIN_DIR/${CT_TARGET}"@" .config
#RUN ct-ng build
ENV PATH $PATH:$TOOLCHAIN_DIR/arm-armv7hf-linux-gnueabi/bin/

ENV CCFLAGS -march=armv7-a-mfloat-abi=hardfp
ENV AR arm-armv7hf-linux-gnueabi-ar
ENV CC arm-armv7hf-linux-gnueabi-gcc
ENV CXX arm-armv7hf-linux-gnueabi-g++
ENV LINK arm-armv7hf-linux-gnueabi-g++
ENV CPP "arm-armv7hf-linux-gnueabi-gcc -E"
ENV LD arm-armv7hf-linux-gnueabi-g++
ENV AS arm-armv7hf-linux-gnueabi-as
ENV CCLD "arm-armv7hf-linux-gnueabi-gcc ${CCFLAGS}"
ENV NM arm-armv7hf-linux-gnueabi-nm
ENV STRIP arm-armv7hf-linux-gnueabi-strip
ENV OBJCOPY arm-armv7hf-linux-gnueabi-objcopy
ENV RANLIB arm-armv7hf-linux-gnueabi-ranlib
ENV F77 "arm-armv7hf-linux-gnueabi-g77 ${CCFLAGS}"
RUN unset LIBC

RUN apt-get update &&\
        apt-get install -y wget unzip
		
#RUN     wget https://github.com/lshjn/docker-335x-test/archive/master.zip &&\
#        unzip master.zip &&\
#        cd docker-335x-test-master &&\
#        $TOOLCHAIN_DIR/bin/arm-armv7hf-linux-gnueabi-gcc -o test test.c
#第二阶段，新建基于busybox的镜像，里面包括程序运行需要的必要环境
FROM  balenalib/generic-armv7ahf-alpine-node
WORKDIR /work_test
#COPY --from=builder /work/docker-335x-test-master/test .
COPY --from=builder /opt/crosstool-ng-1.17.0/find.log .
CMD ["/bin/sh"]
