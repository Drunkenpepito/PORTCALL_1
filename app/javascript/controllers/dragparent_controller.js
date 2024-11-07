import { Controller } from "@hotwired/stimulus"
import { patch } from "@rails/request.js"; // to help the http request

export default class extends Controller {
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
    // console.log(ev.target.id)
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
    // console.log(data)
    console.log(draggedElement)
    console.log(targetElement)

    // Check if the drop target is a valid drop zone
    if (targetElement && targetElement.id && targetElement !== draggedElement) {
      // Update the ancestry of the dragged element
      console.log(`Dragged element ID: ${draggedElement.id}`)
      console.log(`Dropped on element ID: ${targetElement.id}`)
      const url = "/services/change_ancestry"
      patch(url,{
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').getAttribute('content')
        },
        body: JSON.stringify({
          id: draggedElement.id,
          parent_id: targetElement.id
        })
      })

    }
  }
}
