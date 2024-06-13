import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["message"]

  connect() {
    this.timer = setTimeout(() => {
      this.dismiss();
    }, 10000);
  }

  dismiss() {
    this.messageTarget.remove();
  }

  disconnect() {
    clearTimeout(this.timer);
  }
}