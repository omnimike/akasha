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
  'hermes-agent.container'
)
sha256sums=(
  'SKIP'
  'SKIP'
)

package() {
  # Install the Quadlet container files
  install -Dm644 "${srcdir}/vllm-qwen36.container" "${pkgdir}/usr/share/containers/systemd/vllm-qwen36.container"
  install -Dm644 "${srcdir}/hermes-agent.container" "${pkgdir}/usr/share/containers/systemd/hermes-agent.container"

  # Create data directories
  install -d -m 755 "${pkgdir}/var/lib/models/vllm"
  install -d -m 755 "${pkgdir}/var/lib/models/hermes"
}

