import { Controller } from "@hotwired/stimulus"
import {Sortable} from "sortablejs"
import { patch } from "@rails/request.js"; // to help the http request

// Connects to data-controller="drag-and-drop"
export default class extends Controller {
  connect() {
    // creation des elements drag and dropable ICI tous les enfants du controller
    // AKA les turbo_frames de variables
    this.sortable = Sortable.create(this.element,{
    onEnd: this.end.bind(this) //callback sur l'event onEnd qui se déclenche
    // lorsqu'un élément a été déplacé
  })
}


  end(event){
    const url = event.item.dataset.url
    console.log(url)
    // generate the url based on service_ingredient id from turbo_frame_id
    patch(url, {
      body: JSON.stringify({ position: event.newIndex + 1 })
    })
  }
}
