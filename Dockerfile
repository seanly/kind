FROM kindest/node:v1.27.3 as v1.27.3
FROM kindest/node:v1.26.6 as v1.26.6
FROM kindest/node:v1.25.11 as v1.25.11
FROM kindest/node:v1.24.15 as v1.24.15
FROM kindest/node:v1.23.17 as v1.23.17
FROM kindest/node:v1.22.17 as v1.22.17
FROM kindest/node:v1.21.14 as v1.21.14

# Build hostpath-provisioner
FROM golang:1.20.5 as hostpath-provisioner-builder

RUN git clone -b v9.0.3 --depth 1 https://github.com/kubernetes-sigs/sig-storage-lib-external-provisioner /build

WORKDIR /build/examples/hostpath-provisioner

RUN go mod tidy

RUN set -eux \
    ; VERSION=$(git rev-parse --short HEAD) \
    ; OS="$(uname | tr '[:upper:]' '[:lower:]')" \
    ; ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" \
    ;case "$ARCH" in \
		arm64) \
            CGO_ENABLED=0 GOARCH=${ARCH} go build \
                -a -ldflags '-extldflags "-static"' \
                -o /hostpath-provisioner .;; \
		amd64) \
            CGO_ENABLED=0 GOARCH=${ARCH} go build \
                -a -ldflags '-extldflags "-static"' \
                -o /hostpath-provisioner .;; \
		*) echo >&2 "error: unsupported architecture: '$arch'"; exit 1 ;; \
	esac; 

FROM alpine as hostpath-provisioner

#RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories
RUN apk update && apk add --update --no-cache curl bash

COPY --from=hostpath-provisioner-builder /hostpath-provisioner /hostpath-provisioner

CMD ["/hostpath-provisioner"]
