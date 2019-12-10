#第一阶段，创建一个ubuntu的容器，里面安装gcc编译工具，并下载源码编译
#对不同的架构需要安装相应的gcc工具链，这里演示x86平台
FROM lshjn/armv7hf-toolchain-test:gcc7.4.0 as builder
WORKDIR /work_app		
RUN     wget https://github.com/lshjn/docker-335x-test/archive/master.zip &&\
        unzip master.zip &&\
        cd docker-335x-test-master &&\
        arm-armv7hf-linux-gnueabi-gcc -o test1 test.c &&\
		cp test1 /work_app
#第二阶段，新建基于busybox的镜像，里面包括程序运行需要的必要环境
FROM  arm32v7/alpine
WORKDIR /work_test
COPY --from=builder /work_app/test1 .
CMD ["/bin/sh"]
