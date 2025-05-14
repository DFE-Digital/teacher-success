import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["banner"]

  connect() {
    // Show cookies banner if there is no accept/reject cookie
    if (!this.getCookie("cookie_consent")) {
      this.show()
    }
  }

  accept() {
    this.setCookie("cookie_consent", "accepted", 365)
    this.dismiss()
  }

  reject() {
    this.setCookie("cookie_consent", "rejected", 365)
    this.dismiss()
  }

  dismiss() {
    this.bannerTarget.classList.add("hidden")
  }

  show() {
    this.bannerTarget.classList.remove("hidden")
  }

  setCookie(name, value, days) {
    const expires = new Date(Date.now() + days * 864e5).toUTCString()
    document.cookie = `${name}=${value}; expires=${expires}; path=/`
  }

  getCookie(name) {
    return document.cookie
      .split("; ")
      .find(row => row.startsWith(`${name}=`))
      ?.split("=")[1]
  }
}
