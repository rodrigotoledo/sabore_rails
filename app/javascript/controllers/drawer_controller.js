import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["overlay", "panel"]

  connect() {
    this.escapeKeyListener = this.handleEscapeKey.bind(this)
  }

  disconnect() {
    document.removeEventListener("keydown", this.escapeKeyListener)
  }

  toggle() {
    if (this.overlayTarget.classList.contains("hidden")) {
      this.open()
    } else {
      this.close()
    }
  }

  open() {
    this.overlayTarget.classList.remove("hidden")

    // Force reflow para garantir que as classes de transição funcionem
    this.overlayTarget.offsetHeight

    // Animar o panel deslizando para dentro
    requestAnimationFrame(() => {
      this.panelTarget.classList.remove("translate-x-full")
    })

    // Prevenir scroll do body
    document.body.style.overflow = "hidden"
    document.addEventListener("keydown", this.escapeKeyListener)
  }

  close() {
    // Animar o panel deslizando para fora
    this.panelTarget.classList.add("translate-x-full")

    // Restaurar scroll do body
    document.body.style.overflow = ""
    document.removeEventListener("keydown", this.escapeKeyListener)

    // Esconder o overlay após a animação
    setTimeout(() => {
      if (this.hasOverlayTarget) {
        this.overlayTarget.classList.add("hidden")
      }
    }, 300) // Match com duration-300 do CSS
  }

  handleEscapeKey(event) {
    if (event.key === "Escape") {
      this.close()
    }
  }
}
