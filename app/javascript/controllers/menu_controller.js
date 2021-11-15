import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [
    "mapLink"
  ]

  static values = {
    "viewMapText" : String,
    "installMapText": String,
  }

  toggleMapLink(event) {
    event.preventDefault();

    if (this.mapLinkTarget.textContent = this.viewMapTextValue) {
      this.mapLinkTarget.textContent = this.installMapTextValue;
    } else {
      this.mapLinkTarget.textContent = this.viewMapTextValue;
    }
  }
}