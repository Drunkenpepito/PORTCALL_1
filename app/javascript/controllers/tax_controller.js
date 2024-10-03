import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tax"
export default class extends Controller {
  connect() {
    console.log('tax connected')

  }
}
