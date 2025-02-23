import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggle-family"
export default class extends Controller {
  static targets = ["budget"]
  connect() {
    console.log('toggle_Budget connected')
    console.log(this)
  }
  toggle(){
    this.budgetTarget.classList.toggle("d-none") 
    //
  }
}
