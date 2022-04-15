import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "panel"
  ]

  hidePanel() {
    this.panelTarget.classList.add("hidden");
  }

  showPanel() {
    this.panelTarget.classList.remove("hidden");
  }
}
