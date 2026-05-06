import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["overlay"]

  connect() {
    const frame = document.getElementById("modal_frame")
    if (!frame) return

    // Cierra el modal automáticamente cuando el turbo_stream vacía el frame
    this._observer = new MutationObserver(() => {
      if (this.overlayTarget.classList.contains("flex") && !frame.innerHTML.trim()) {
        this.close()
      }
    })
    this._observer.observe(frame, { childList: true, subtree: true })
  }

  disconnect() {
    this._observer?.disconnect()
  }

  open() {
    this.overlayTarget.classList.remove("hidden")
    this.overlayTarget.classList.add("flex")
  }

  close() {
    this.overlayTarget.classList.add("hidden")
    this.overlayTarget.classList.remove("flex")
    const frame = document.getElementById("modal_frame")
    if (frame) frame.innerHTML = ""
  }
}
