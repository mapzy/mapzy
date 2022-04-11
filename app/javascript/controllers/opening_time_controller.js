import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "opensAt",
    "closesAt",
    "timesBlock",
    "closed",
    "closedBlock",
    "open24h",
    "open24hBlock",
    "openingTimes",
    "openingTimesBlock"
  ]

  connect() {
    // hide opening times block if already checked
    if (this.openingTimesTarget.checked) {
      this.openingTimesBlockTarget.classList.add("hidden")
    }

    // hide opening time block if closed already checked
    this.closedTargets.forEach((target, index) =>{
      if (target.checked) {
        this.toggleClosed(target, index)
      }
    })

    // hide opening time block if open24h already checked
    this.open24hTargets.forEach((target, index) =>{
      if (target.checked) {
        this.toggleOpen24h(target, index)
      }
    })
  }

  toggleOpeningTimes() {
    this.openingTimesBlockTarget.classList.toggle("hidden")
  }

  toggleClosedEl(e) {
    this.toggleClosed(e.target, e.params["index"])
  }

  toggleOpen24hEl(e) {
    this.toggleOpen24h(e.target, e.params["index"])
  }

  toggleClosed(target, index) {
    this.open24hBlockTargets[index].classList.toggle("hidden")
    this.timesBlockTargets[index].classList.toggle("hidden")

    if (target.checked) {
      this.clearTimes(index)
      this.clearOpen24h(index)
    } else {
      this.addDefaultTimes(index)
    }
  }

  toggleOpen24h(target, index) {
    this.closedBlockTargets[index].classList.toggle("hidden")
    this.timesBlockTargets[index].classList.toggle("hidden")

    if (target.checked) {
      this.clearTimes(index)
      this.clearClosed(index)
    } else {
      this.addDefaultTimes(index)
    }
  }

  clearTimes(index) {
    this.opensAtTargets[index].value = ""
    this.closesAtTargets[index].value = ""
  }

  clearOpen24h(index) {
    this.open24hTargets[index].checked = false;
  }

  clearClosed(index) {
    this.closedTargets[index].checked = false;
  }

  addDefaultTimes(index) {
    this.opensAtTargets[index].value = "08:00"
    this.closesAtTargets[index].value = "18:00"
  }
}
