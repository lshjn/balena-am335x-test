#��һ�׶Σ�����һ��ubuntu�����������氲װgcc���빤�ߣ�������Դ�����
#�Բ�ͬ�ļܹ���Ҫ��װ��Ӧ��gcc��������������ʾx86ƽ̨
FROM lshjn/armv7hf-toolchain-test:gcc7.4.0 as builder
WORKDIR /work_app		
RUN     wget https://github.com/lshjn/docker-335x-test/archive/master.zip &&\
        unzip master.zip &&\
        cd docker-335x-test-master &&\
        arm-armv7hf-linux-gnueabi-gcc -o test1 test.c &&\
		cp test1 /work_app
#�ڶ��׶Σ��½�����busybox�ľ��������������������Ҫ�ı�Ҫ����
FROM  busybox@sha256:783d05e2c73f48d4499387b807caf11b0b3afef5e17e225643b4b4558b21e221
WORKDIR /work_test
COPY --from=builder /work_app/test1 .
CMD ["/bin/sh"]
