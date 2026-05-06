import { Controller } from "@hotwired/stimulus"

const CIRCUMFERENCE = 2 * Math.PI * 88  // r=88 → ≈552.9

export default class extends Controller {
  static targets = ["display", "ring", "btn", "label", "dots"]

  connect() {
    this.FOCUS_SECS  = 25 * 60
    this.BREAK_SECS  = 5  * 60
    this.remaining   = this.FOCUS_SECS
    this.total       = this.FOCUS_SECS
    this.running     = false
    this.onBreak     = false
    this.cycles      = 0
    this._render()
  }

  disconnect() {
    clearInterval(this._timer)
  }

  toggle() {
    this.running ? this._pause() : this._start()
  }

  reset() {
    clearInterval(this._timer)
    this.running   = false
    this.onBreak   = false
    this.remaining = this.FOCUS_SECS
    this.total     = this.FOCUS_SECS
    this.btnTarget.textContent = "Iniciar"
    this._render()
  }

  _start() {
    this.running = true
    this.btnTarget.textContent = "Pausar"
    this._timer = setInterval(() => {
      this.remaining -= 1
      this._render()
      if (this.remaining <= 0) this._cycleEnd()
    }, 1000)
  }

  _pause() {
    this.running = false
    this.btnTarget.textContent = "Continuar"
    clearInterval(this._timer)
  }

  _cycleEnd() {
    clearInterval(this._timer)
    this.running = false

    if (!this.onBreak) {
      this.cycles = Math.min(this.cycles + 1, 4)
      this._updateDots()
      this.onBreak   = true
      this.remaining = this.BREAK_SECS
      this.total     = this.BREAK_SECS
      this.btnTarget.textContent = "Iniciar descanso"
      new Audio("https://assets.mixkit.co/active_storage/sfx/2869/2869-preview.mp3").play().catch(() => {})
    } else {
      this.onBreak   = false
      this.remaining = this.FOCUS_SECS
      this.total     = this.FOCUS_SECS
      this.btnTarget.textContent = "Iniciar"
    }
    this._render()
  }

  _render() {
    const mins = String(Math.floor(this.remaining / 60)).padStart(2, "0")
    const secs = String(this.remaining % 60).padStart(2, "0")
    this.displayTarget.textContent = `${mins}:${secs}`
    this.labelTarget.textContent   = this.onBreak ? "Descanso" : "Foco"

    const progress  = this.remaining / this.total
    const offset    = CIRCUMFERENCE * (1 - progress)
    this.ringTarget.style.strokeDashoffset = offset

    // Cambio de color al descanso
    this.ringTarget.style.stroke = this.onBreak ? "#a78bfa" : "#f97316"
  }

  _updateDots() {
    const dots = this.dotsTarget.querySelectorAll("[data-dot-index]")
    dots.forEach((dot, i) => {
      dot.classList.toggle("bg-orange-500", i < this.cycles)
      dot.classList.toggle("bg-orange-200", i >= this.cycles)
    })
  }
}
