import { Controller } from "stimulus";

export default class extends Controller {
  static targets = [
    "times",
    "closed",
    "closedBlock",
    "open24h",
    "open24hBlock"
  ]

  initialize() {
    this.toggleClosed = this.toggleClosed.bind(this)
    this.toggleOpen24h = this.toggleOpen24h.bind(this)
  }

  connect() {
    if (!this.closedTarget) return
    if (!this.open24hTarget) return

    this.closedTarget.addEventListener('change', this.toggleClosed)
    this.open24hTarget.addEventListener('change', this.toggleOpen24h)
  }

  disconnect() {
    if (!this.closedTarget) return
    if (!this.open24hTarget) return

    this.closedTarget.removeEventListener('change', this.toggleClosed)
    this.open24hTarget.removeEventListener('change', this.toggleOpen24h)
  }

  toggleClosed(e) {
    if (this.closedTarget.checked) {
      this.timesTarget.classList.add("hidden")
      this.open24hBlockTarget.classList.add("hidden")
    } else {
      this.timesTarget.classList.remove("hidden")
      this.open24hBlockTarget.classList.remove("hidden")
    }
  }

  toggleOpen24h(e) {
    if (this.open24hTarget.checked) {
      this.timesTarget.classList.add("hidden")
      this.closedBlockTarget.classList.add("hidden")
    } else {
      this.timesTarget.classList.remove("hidden")
      this.closedBlockTarget.classList.remove("hidden")
    }
  }
}