# vim: ft=dockerfile

FROM centos:8

RUN dnf makecache && \
    dnf install -y epel-release dnf-utils && \
    dnf config-manager --set-enabled powertools && \
    dnf makecache

# overlay2 bug with yum/dnf
#
# OverlayFS only implements a subset of POSIX standards. This can cause RPM db corruption.
# See bottom of https://docs.docker.com/storage/storagedriver/overlayfs-driver/
# Since there is no dnf-plugin-ovl for CentOS 8 yet, we need to touch /var/lib/rpm/* before
# 'dnf install' to avoid the issue.

# Dev dependencies
RUN touch /var/lib/rpm/* &&   \
    dnf install -y            \
    git                       \
    make                      \
    rpm-build                 \
    epel-rpm-macros           \
    virt-install              \
    python3-devel             \
    python3-setuptools        \
    python3-sphinx            \
    python3-distro            \
    python3-netifaces         \
    python3-libvirt

COPY . /usr/src/koan
WORKDIR /usr/src/koan

VOLUME /usr/src/koan/rpm-build

CMD ["/bin/bash", "-c", "make rpms"]
