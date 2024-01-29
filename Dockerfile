FROM kindest/node:v1.27.3 as v1.27.3
FROM kindest/node:v1.26.6 as v1.26.6
FROM kindest/node:v1.25.11 as v1.25.11
FROM kindest/node:v1.24.15 as v1.24.15
FROM kindest/node:v1.23.17 as v1.23.17
FROM kindest/node:v1.22.17 as v1.22.17
FROM kindest/node:v1.21.14 as v1.21.14

# Build local-path-provisioner
FROM golang:1.21 as lpp-builder

ARG LPP_VERSION=v0.0.26

RUN git clone -b ${LPP_VERSION} --depth 1 https://github.com/seanly/local-path-provisioner /build

WORKDIR /build/

RUN go mod tidy

RUN set -eux \
    ; VERSION=$(git rev-parse --short HEAD) \
    ; OS="$(uname | tr '[:upper:]' '[:lower:]')" \
    ; ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" \
    ;case "$ARCH" in \
		arm64) \
            CGO_ENABLED=0 GOARCH=${ARCH} go build \
                -a -ldflags '-extldflags "-static"' \
                -o local-path-provisioner .;; \
		amd64) \
            CGO_ENABLED=0 GOARCH=${ARCH} go build \
                -a -ldflags '-extldflags "-static"' \
                -o local-path-provisioner .;; \
		*) echo >&2 "error: unsupported architecture: '$arch'"; exit 1 ;; \
	esac; 

FROM alpine as local-path-provisioner

#RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories
RUN apk update && apk add --update --no-cache curl bash
RUN apk upgrade --no-cache busybox zlib

COPY --from=lpp-builder /build/local-path-provisioner /usr/bin/local-path-provisioner
CMD ["local-path-provisioner"]
