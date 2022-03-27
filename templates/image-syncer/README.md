# image-syncer 

用于同步镜像到目标仓库

## images.yaml 格式

配置 `coderepo.filepath` 变量的文件格式

```yaml

registry: registry.cn-chengdu.aliyuncs.com
namespace: k8ops
images:
  - src: traefik:v2.5
    dest: traefik:v2.5
  - src: traefik:v2.6
    dest: traefik:v2.6

```

# 参数配置样例
