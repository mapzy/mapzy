import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [
    "embedCode",
    "embedCodeLink"
  ]

  toggleEmbedCode(event) {
    event.preventDefault();

    if (this.embedCodeTarget.classList.contains("hidden")) {
      this.showEmbedCode();
      this.embedCodeLinkTarget.textContent = "Hide Embed Code";
    } else {
      this.hideEmbedCode();
      this.embedCodeLinkTarget.textContent = "Show Embed Code";
    }
  }

  showEmbedCode() {
    this.embedCodeTarget.classList.remove("hidden");
  }

  hideEmbedCode() {
    this.embedCodeTarget.classList.add("hidden");
  }
}