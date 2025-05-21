import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
//= require rails-ujs

application.debug = false
window.Stimulus   = application

export { application }
