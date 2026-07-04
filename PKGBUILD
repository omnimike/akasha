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
  'systemd'
)
backup=('etc/local-agents/hermes-agent.env')
install=local-agents.install
source=(
  'vllm-qwen36.container'
  'hermes-agent.container'
  'hermes-agent.env'
  'hermes-agent-setup'
  'hermes'
  'sysusers.local-agents'
)
sha256sums=(
  'SKIP'
  'SKIP'
  'SKIP'
  'SKIP'
  'SKIP'
  'SKIP'
)

package() {
  # Install the Quadlet container files
  install -Dm644 "${srcdir}/vllm-qwen36.container" "${pkgdir}/usr/share/containers/systemd/vllm-qwen36.container"
  install -Dm644 "${srcdir}/hermes-agent.container" "${pkgdir}/usr/share/containers/systemd/hermes-agent.container"

  # Install sysusers file for the vllm user
  install -Dm644 "${srcdir}/sysusers.local-agents" "${pkgdir}/usr/lib/sysusers.d/local-agents.conf"

  # Create data directories
  install -d -m 2755 -o 2000 -g 0 "${pkgdir}/var/lib/${pkgname}/vllm"
  install -d -m 2700 -o 10000 -g 0 "${pkgdir}/var/lib/${pkgname}/hermes"

  # Install secrets template (user must fill in before starting)
  install -Dm644 "${srcdir}/hermes-agent.env" "${pkgdir}/etc/local-agents/hermes-agent.env"

  # Install interactive setup helper
  install -Dm755 "${srcdir}/hermes-agent-setup" "${pkgdir}/usr/bin/hermes-agent-setup"

  # Install CLI chat wrapper
  install -Dm755 "${srcdir}/hermes" "${pkgdir}/usr/bin/hermes"
}

