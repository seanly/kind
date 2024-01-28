FROM kindest/node:v1.27.3 as v1.27.3
FROM kindest/node:v1.26.6 as v1.26.6
FROM kindest/node:v1.25.11 as v1.25.11
FROM kindest/node:v1.24.15 as v1.24.15
FROM kindest/node:v1.23.17 as v1.23.17
FROM kindest/node:v1.22.17 as v1.22.17
FROM kindest/node:v1.21.14 as v1.21.14

FROM mauilion/hostpath-provisioner:dev as hostpath-provisioner