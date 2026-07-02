# Maintainer: Michael F <michael.fulthorp@gmail.com>
pkgname=local-agents
pkgver=0.0.1
pkgrel=1
pkgdesc="Local LLMs running on my home server"
arch=('x86_64')
license=('MIT')
depends=(
  'podman'
  'nvidia-container-toolkit'
)
makedepends=('buildah')
source=(
  'Containerfile'
  'vllm-qwen36.service'
  'local-agents.target'
)
sha256sums=('SKIP' 'SKIP' 'SKIP')

build() {
  echo "--- Building monolithic SIF image using buildah ---"
  buildah bud \
    --isolation=chroot \
    -f "${srcdir}/Containerfile" \
    -o sif="${srcdir}/local-agents.sif" \
    "${srcdir}"
}

package() {
  # Container SIF file
  install -Dm644 "${srcdir}/local-agents.sif" "${pkgdir}/usr/share/${pkgname}/local-agents.sif"

  # Systemd units
  install -Dm644 "${srcdir}/vllm-qwen36.service" "${pkgdir}/usr/lib/systemd/system/vllm-qwen36.service"
  install -Dm644 "${srcdir}/local-agents.target" "${pkgdir}/usr/lib/systemd/system/local-agents.target"
}
