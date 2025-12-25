import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "panel"]
  static values = { active: String }

  connect() {
    this.showTab(this.activeValue || this.tabTargets[0].dataset.tab)
  }

  select(event) {
    const tab = event.currentTarget.dataset.tab
    this.showTab(tab)

    // Atualizar URL sem recarregar página
    const url = new URL(window.location.href)
    url.searchParams.set('tab', tab)
    window.history.replaceState(null, '', url)
  }

  showTab(activeTab) {
    this.tabTargets.forEach(tab => {
      const isActive = tab.dataset.tab === activeTab
      tab.classList.toggle('border-yellow-500', isActive)
      tab.classList.toggle('text-yellow-600', isActive)
      tab.classList.toggle('border-transparent', !isActive)
      tab.classList.toggle('text-gray-500', !isActive)
    })

    this.panelTargets.forEach(panel => {
      panel.classList.toggle('hidden', panel.dataset.tab !== activeTab)
    })
  }
}
