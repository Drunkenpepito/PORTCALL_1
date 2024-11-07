import { Controller } from "@hotwired/stimulus"
import {Sortable} from "sortablejs"
import { patch } from "@rails/request.js"; // to help the http request

// Connects to data-controller="drag-and-drop"
export default class extends Controller {
  connect() {
    //  console.log(this.element)
    // creation des elements drag and dropable ICI tous les enfants du controller
    // AKA les turbo_frames de variables
    console.log('drag & drop controller connected')
    // console.log(this.element.dataset)
    this.sortable = Sortable.create(this.element,{
    onEnd: this.end.bind(this) //callback sur l'event onEnd qui se déclenche
    // lorsqu'un élément a été déplacé
  })
  // console.log(this.sortable)
}

// au moment du drop , on doit avoir la position de la variable droppée qui prend la position de la variable remplacée
// pas clair : demander a Benoit
  end(event){
    const url = event.item.dataset.url
     console.log(event)
    //  console.log(event.item)
    //  console.log(event.item.dataset)
    // console.log(event.item.dataset.url)
    // generate the url based on service_ingredient id from turbo_frame_id
    patch(url, {
      body: JSON.stringify({ position: event.newIndex + 1 })
    })
    console.log(event)
  }
}
