import { Controller } from "@hotwired/stimulus"

const EVENT_TYPE = "tracked_link_clicked"

export default class extends Controller {
  static targets = ["link"]

  track(event) {
    event.preventDefault()

    // Timeout to redirect anyway, even if the event hasn't completed
    setTimeout(() => { this.redirect(); }, 100);

    let trackedLinkText;
    if (this.linkTarget.dataset.trackedLinkText) {
      trackedLinkText = this.linkTarget.dataset.trackedLinkText;
    } else {
      trackedLinkText = this.linkTarget.innerText;
    }

    let trackedLinkHref;
    if (this.linkTarget.dataset.trackedLinkHref) {
      trackedLinkHref = this.linkTarget.dataset.trackedLinkHref;
    } else {
      trackedLinkHref = this.linkTarget.href;
    }

    // Send analytics event via Rails endpoint
    fetch("/events", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("meta[name=csrf-token]").content
      },
      body: JSON.stringify({
        event: {
          type: EVENT_TYPE,
          data: {
            link_type: this.linkTarget.dataset.linkType,
            link_subject: this.linkTarget.dataset.linkSubject,
            text: trackedLinkText,
            href: trackedLinkHref,
            mouse_button: event.button,
          } 
        }
      })
    }).finally(() => {
      this.redirect()
    })
  }

  redirect() {
    window.location = this.linkTarget.href
  }
}
