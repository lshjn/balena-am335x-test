FROM lshjn/alpine:gcc_8.3.0 as get_env 
WORKDIR /		

FROM lshjn/armv7hf-toolchain:musl_gcc8.3.0_env as builder 
WORKDIR /alpine_rootfs
ENV CCFLAGS -march=armv7-a -mfloat-abi=hard

COPY --from=get_env /bin bin/ 
COPY --from=get_env /bin etc/ 
COPY --from=get_env /bin sbin/ 
COPY --from=get_env /usr usr/
COPY --from=get_env /lib lib/

RUN cp /alpine_rootfs/usr/lib/gcc/armv7-alpine-linux-musleabihf/8.3.0/* /opt/toolchain/arm-armv7hf-linux-musleabi/lib/gcc/arm-armv7hf-linux-musleabi/8.3.0/ -rf

RUN     wget https://github.com/lshjn/docker-335x-test/archive/master.zip &&\
        unzip master.zip &&\
        cd docker-335x-test-master&&\ 
	arm-armv7hf-linux-musleabi-gcc -march=armv7-a -marm -mthumb-interwork -mfloat-abi=hard -mfpu=neon -mtune=cortex-a8 --sysroot=/alpine_rootfs -o test test.c

FROM arm32v7/alpine
WORKDIR /app

COPY --from=builder /alpine_rootfs/docker-335x-test-master/test .


CMD ["/bin/sh"]
