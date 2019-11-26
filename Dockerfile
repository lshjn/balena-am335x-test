FROM balenalib/generic-armv7ahf-alpine-node:latest as builder

#�����Լ��Ĵ���
WORKDIR /work
RUN     wget https://github.com/lshjn/balena-am335x-test/archive/master.zip &&\
        unzip master.zip &&\
        cd balena-am335x-test &&\
        arm-armv7hf-linux-gnueabi-gcc -o test test.c
#�ڶ��׶Σ��½�����busybox�ľ��������������������Ҫ�ı�Ҫ����
FROM busybox@sha256:093e639c8b7ff67d878116d3de9e3e91ff1bd0d6e4141ae4019ca3fb3e493df9
WORKDIR /work_test
COPY --from=builder /work/balena-am335x-test/test .
CMD ["./test"]		