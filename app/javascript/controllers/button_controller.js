import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button"];

  disable() {
    this.buttonTarget.textContent = "Finding the quote..."
    this.buttonTarget.classList.remove("btn--primary");
    this.buttonTarget.classList.add("btn--disabled");

    // Interestingly, actually disabling the button will not allow the AI text to render. It probably requires some
    // more finagling time with Turbo or Stimulus that I don't have right now.
    // this.buttonTarget.setAttribute("disabled", "disabled");
  }
}
