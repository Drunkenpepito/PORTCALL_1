import { Controller } from "@hotwired/stimulus"
import { patch } from "@rails/request.js"; // to help the http request


export default class extends Controller {
  static values = { type: String  }
  connect() {
    // Add the event listeners for drag and drop
    // bind the event handlers to the controller functions
    this.element.addEventListener("dragstart", this.dragstartHandler.bind(this))
    this.element.addEventListener("dragover", this.dragoverHandler.bind(this))
    this.element.addEventListener("drop", this.dropHandler.bind(this))
  }

  dragstartHandler(ev) {
    // triggered when the user starts dragging an element
    // Add the target element's id to the data transfer object
    // console.log(ev.target)

    ev.dataTransfer.setData("og_service_id", ev.target.id)
  }

  dragoverHandler(ev) {
    // triggered when an element or text selection is being dragged over a valid drop target
    // Prevent default to allow drop
    ev.preventDefault()
    
  }

  dropHandler(ev) {
    // triggered when an element or text selection is dropped on a valid drop target
    // Prevent default action (open as link for some elements)
    ev.preventDefault()
    // Get the id of the target and add the moved element to the target's DOM
    const og_service_id = ev.dataTransfer.getData("og_service_id")
    const draggedElement = document.getElementById(og_service_id)
    const targetElement = ev.target
    const targetType = targetElement.tagName.toLowerCase();
    // console.log(og_service_id)
    // console.log(draggedElement.id)
    // console.log(targetElement.id)
    // console.log(targetType)
    // console.log(ev.target)

    // Check if the drop target is a valid drop zone
    if (targetElement && targetElement.id && targetElement !== draggedElement) {
    

      const url = `/${this.typeValue}/change_ancestry`
      console.log(url)
      patch(url,{
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').getAttribute('content')
        },
        body: JSON.stringify({
          id: draggedElement.id,
          parent_id: targetElement.id,
          target_type: targetType // Add the target type to the request body
        })
      })

    }
  }
}











// import { Controller } from "@hotwired/stimulus"
// import {Sortable} from "sortablejs"
// import { patch } from "@rails/request.js"; 

// // Connects to data-controller="drag-to-parent"
// export default class extends Controller {
//   connect() {
//     console.log('drag to parent controller connected')
//     // console.log(this.element)
//     this.sortable = Sortable.create(this.element,{
//     onEnd: this.end.bind(this) 
//     })
//   }

//   end(event){
//     const url = event.item.dataset.url
//      console.log(event.item.dataset)

//     patch(url, {
//       body: JSON.stringify({ position: event.newIndex + 1 })
//     })
//     // console.log(event)
//   }
// }



