FROM lshjn/armv7hf-toolchain:musl_gcc8.3.0_crosscompile_ok as builder
WORKDIR /my_app

RUN     wget https://github.com/lshjn/docker-335x-test/archive/master.zip &&\
        unzip master.zip &&\
        cd docker-335x-test-master&&\
        arm-armv7hf-linux-musleabi-gcc $CCFLAGS -o test test.c

FROM arm32v7/alpine
WORKDIR /app

COPY --from=builder /my_app/docker-335x-test-master/test .


CMD ["/bin/sh"]
