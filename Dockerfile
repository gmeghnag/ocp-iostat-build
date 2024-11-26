FROM registry.access.redhat.com/ubi9/ubi-minimal:9.4-1227.1726694542@sha256:c0e70387664f30cd9cf2795b547e4a9a51002c44a4a86aa9335ab030134bf392

ARG \
  GIT_REVISION=updateme \
  APP_VERSION=updateme \
  #The default is Never (case insensitive) but can be set to hours, days or weeks e.g. 1h, 2d, 3w
  QUAY_TAG_EXPIRATION=180d

ENV \
  LANG='en_US.UTF-8' \
  LANGUAGE='en_US:en' \
  LC_ALL='en_US.UTF-8' \
  TZ=UTC

COPY ./rootfs /

## https://github.com/hadolint/hadolint/wiki/DL4006
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

LABEL \
  org.opencontainers.image.title="${IMAGE_NAME}" \
  org.opencontainers.image.version="v${APP_VERSION}" \
  org.opencontainers.image.description="example entitled build" \
  org.opencontainers.image.url="https://registry.example.com/repository/pipelines/entitled-builds" \
  org.opencontainers.image.documentation="https://github.com/containers" \
  org.opencontainers.image.source="https://github.example.com/Containers/images" \
  org.opencontainers.image.revision="${GIT_REVISION}" \
  org.opencontainers.image.authors="Example Cloud Platform" \
  org.opencontainers.image.base.name="registry.access.redhat.com/ubi9/ubi-minimal" \
  org.opencontainers.image.vendor="Redhat" \
  org.opencontainers.image.licenses="Apache-2.0" \
  quay.expires-after="$QUAY_TAG_EXPIRATION"

RUN set -ex && \
  #################################################################
  # Configure the locale
  #################################################################
  sed -i 's/^LANG=.*/LANG="en_US.utf8"/' /etc/locale.conf && \
  #################################################################
  # Configure timezone
  #################################################################
  ln -fvs /usr/share/zoneinfo/America/New_York /etc/localtime && \
  #################################################################
  # package dependecies
  #################################################################
  PKGMGR='microdnf' && \
  BUILDTIME_PKGS="" && \
  RUNTIME_PKGS="glibc-langpack-en nss_wrapper uid_wrapper sysstat" && \
  #################################################################
  ## Update the image
  #################################################################
  #${PKGMGR} upgrade -y --refresh --nodocs --setopt=install_weak_deps=0 && \
  #################################################################
  # Install packages
  # --disableplugin=subscription-manager
  #################################################################
  ls -lah /etc/pki/entitlement && \
  ${PKGMGR} \
  --enablerepo="ubi-9-appstream-rpms" \
  --enablerepo="ubi-9-baseos-rpms" \
  --enablerepo="ubi-9-codeready-builder-rpms" \
  --enablerepo="rhel-9-for-x86_64-baseos-rpms" \
  --enablerepo="rhel-9-for-x86_64-appstream-rpms" \
  --enablerepo="codeready-builder-for-rhel-9-x86_64-rpms" \
  install --nodocs --best --assumeyes --setopt=tsflags=nodocs --setopt=install_weak_deps=0 \
  ${BUILDTIME_PKGS} ${RUNTIME_PKGS}
