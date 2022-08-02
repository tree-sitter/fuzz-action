FROM alpine:3.16

RUN apk update && apk upgrade

RUN apk add git clang rustup build-base pkgconf jq

RUN rustup-init -y
RUN echo "source /root/.cargo/env" >> /root/.profile

RUN git clone https://github.com/tree-sitter/tree-sitter /tmp/tree-sitter
RUN cd /tmp/tree-sitter && make && make install
RUN cd /tmp/tree-sitter && /root/.cargo/bin/cargo install --path cli/

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
