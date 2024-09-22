import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tweet"
export default class extends Controller {
  static targets = [ "modal" ];

  open() {
    this.modalTarget.classList.remove('hidden');
  }

  close() {
    this.modalTarget.classList.add('hidden');
  }
}
