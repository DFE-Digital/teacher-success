import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["banner"]

  connect() {
    // Show cookies banner if there is no preference set for non-essential cookies
    if (this.getCookie("teach_preferences").nonEssential === undefined) {
      this.show()
    }
  }

  accept() {
    this.setCookie("teach_preferences", JSON.stringify({ nonEssential: true }), 365)
    this.copyAnalyticsTemplateToPage()
    this.dismiss()
  }

  reject() {
    this.setCookie("teach_preferences", JSON.stringify({ nonEssential: false }), 365)
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
    const cookie = document.cookie
      .split("; ")
      .find(row => row.startsWith(name + "="))

    if (!cookie) return {}; // Cookie doesn't exist

    try {
      return JSON.parse(decodeURIComponent(cookie.split("=")[1]));
    } catch (e) {
      return {};
    }
  }

  copyAnalyticsTemplateToPage() {
    // Copy the template contents to a new <script> tag in the head so that analytics are executed 
    const template = document.getElementById("ga-template")

    template.content.childNodes.forEach(node => {
      if (node.nodeName === "SCRIPT") {
        const script = document.createElement("script");

        Array.from(node.attributes).forEach(attr => {
          script.setAttribute(attr.name, attr.value);
        });

        script.textContent = node.textContent;

        document.head.appendChild(script);
      } else {
        document.head.appendChild(node.cloneNode(true));
      }
    });
  }
}
