import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggle-family"
export default class extends Controller {
  static targets = ["family"]
  connect() {
    this.familyTarget.classList.add("d-none") // Masquer par défaut le submenu orders
    console.log('toggle_Family connected')
    console.log(this)
  }
  toggle(){
    this.familyTarget.classList.toggle("d-none") 
    //
  }
}
