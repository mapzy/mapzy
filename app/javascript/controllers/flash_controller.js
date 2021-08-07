import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["message"]

  connect() {
    setTimeout(() => this.dismiss(), 15000);
  }

  dismiss() {
    this.messageTarget.classList.add("hidden");
  }
}