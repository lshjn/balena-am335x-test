#��һ�׶Σ�����һ��ubuntu�����������氲װgcc���빤�ߣ�������Դ�����
#�Բ�ͬ�ļܹ���Ҫ��װ��Ӧ��gcc��������������ʾx86ƽ̨
FROM lshjn/armv7hf-toolchain:latest as builder
WORKDIR /work_app		
RUN     wget https://github.com/lshjn/docker-335x-test/archive/master.zip &&\
        unzip master.zip &&\
        cd docker-335x-test-master &&\
        arm-armv7hf-linux-gnueabi-gcc -o test test.c &&\
		cp test /work_app
#�ڶ��׶Σ��½�����busybox�ľ��������������������Ҫ�ı�Ҫ����
FROM  busybox@sha256:7044f6fc222ac87449d87e041eae6b5254012a8b4cbbc35e5b317ac61aa12557
WORKDIR /work_test
COPY --from=builder /work_app/test .
CMD ["/bin/sh"]
