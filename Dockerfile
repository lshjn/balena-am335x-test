#��һ�׶Σ�����һ��ubuntu�����������氲װgcc���빤�ߣ�������Դ�����
#�Բ�ͬ�ļܹ���Ҫ��װ��Ӧ��gcc��������������ʾx86ƽ̨
FROM lshjn/armv7hf-toolchain:latest as builder
		
RUN     wget https://github.com/lshjn/docker-335x-test/archive/master.zip &&\
        unzip master.zip &&\
        cd docker-335x-test-master &&\
        arm-armv7hf-linux-gnueabi-gcc -o test test.c
#�ڶ��׶Σ��½�����busybox�ľ��������������������Ҫ�ı�Ҫ����
FROM  balenalib/generic-armv7ahf-alpine-node
WORKDIR /work_test
COPY --from=builder /work/docker-335x-test-master/test .
CMD ["./test"]
