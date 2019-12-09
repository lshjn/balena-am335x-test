#第一阶段，创建一个ubuntu的容器，里面安装gcc编译工具，并下载源码编译
#对不同的架构需要安装相应的gcc工具链，这里演示x86平台
FROM lshjn/armv7hf-toolchain:latest as builder
WORKDIR /work_app		
RUN     wget https://github.com/lshjn/docker-335x-test/archive/master.zip &&\
        unzip master.zip &&\
        cd docker-335x-test-master &&\
        arm-armv7hf-linux-gnueabi-gcc -o test test.c &&\
		cp test /work_app
#第二阶段，新建基于busybox的镜像，里面包括程序运行需要的必要环境
FROM  busybox@sha256:7044f6fc222ac87449d87e041eae6b5254012a8b4cbbc35e5b317ac61aa12557
WORKDIR /work_test
COPY --from=builder /work_app/test .
CMD ["/bin/sh"]
