import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "opensAt",
    "closesAt",
    "timesBlock",
    "closed",
    "closedBlock",
    "open24h",
    "open24hBlock"
  ]

  initialize() {
    this.toggleClosed = this.toggleClosed.bind(this)
    this.toggleOpen24h = this.toggleOpen24h.bind(this)

    // Call them once to update the view to the status quo
    if (this.open24hTarget.checked) { this.toggleOpen24h() }
    if (this.closedTarget.checked) { this.toggleClosed() }
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
      this.timesBlockTarget.classList.add("hidden")
      this.open24hBlockTarget.classList.add("hidden")
      this.clearTimes()
      this.clearOpen24h()
    } else {
      this.timesBlockTarget.classList.remove("hidden")
      this.open24hBlockTarget.classList.remove("hidden")
      this.addDefaultTimes()
    }
  }

  toggleOpen24h(e) {
    if (this.open24hTarget.checked) {
      this.timesBlockTarget.classList.add("hidden")
      this.closedBlockTarget.classList.add("hidden")
      this.clearTimes()
      this.clearClosed()
    } else {
      this.timesBlockTarget.classList.remove("hidden")
      this.closedBlockTarget.classList.remove("hidden")
      this.addDefaultTimes()
    }
  }

  clearTimes() {
    this.opensAtTarget.value = ""
    this.closesAtTarget.value = ""
  }

  clearOpen24h() {
    this.open24hTarget.checked = false;
  }

  clearClosed() {
    this.closedTarget.checked = false;
  }

  addDefaultTimes() {
    this.opensAtTarget.value = "08:00"
    this.closesAtTarget.value = "18:00"
  }
}