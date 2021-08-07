import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["message"]

  dismiss() {
    this.messageTarget.classList.add("hidden");
  }
}