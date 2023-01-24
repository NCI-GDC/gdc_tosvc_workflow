FROM quay.io/ncigdc/bio-alpine:py36-8dee591

ARG WORKFLOW

COPY ./${WORKFLOW} /opt
# TODO: Copy additional directories as needed
COPY ./main /main

RUN apk add make
RUN make -C /opt init-pip

WORKDIR /opt

ENTRYPOINT ["make"]

CMD ["pack"]
