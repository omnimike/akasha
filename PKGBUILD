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
  'vllm-qwen36.container'
)
sha256sums=('SKIP')

package() {
  # Install the Quadlet container file
  install -Dm644 "${srcdir}/vllm-qwen36.container" "${pkgdir}/usr/share/containers/systemd/vllm-qwen36.container"

  # Create the model cache directory
  install -d -m 755 "${pkgdir}/var/lib/${pkgname}"
}

