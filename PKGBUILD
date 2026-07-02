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
install=local-agents.install
source=(
  'Containerfile'
  'vllm-qwen36.container'
  'local-agents.target'
)
sha256sums=('SKIP' 'SKIP' 'SKIP')

package() {
  # Install the Containerfile for building during installation
  install -Dm644 "${srcdir}/Containerfile" "${pkgdir}/usr/share/${pkgname}/Containerfile"

  # Install the Quadlet container file
  install -Dm644 "${srcdir}/vllm-qwen36.container" "${pkgdir}/usr/share/containers/systemd/vllm-qwen36.container"

  # Install the systemd target
  install -Dm644 "${srcdir}/local-agents.target" "${pkgdir}/usr/lib/systemd/system/local-agents.target"

  # Create the model cache directory
  install -d -m 755 "${pkgdir}/var/lib/${pkgname}"
}

