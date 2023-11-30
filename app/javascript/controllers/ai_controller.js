import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="ai"
export default class extends Controller {
  static targets = ["ai_output"]

  connect(){
    console.log('make sure that this controller has connected!');
  }
}
