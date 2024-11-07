import { Controller } from "@hotwired/stimulus"
import {Sortable} from "sortablejs"
import { patch } from "@rails/request.js"; 

// Connects to data-controller="drag-to-parent"
export default class extends Controller {
  connect() {
    console.log('drag to parent controller connected')
    // console.log(this.element)
    this.sortable = Sortable.create(this.element,{
    onEnd: this.end.bind(this) 
    })
  }

  end(event){
    const url = event.item.dataset.url
     console.log(event.item.dataset)

    patch(url, {
      body: JSON.stringify({ position: event.newIndex + 1 })
    })
    // console.log(event)
  }
}
