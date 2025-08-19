---
title: "Get support"
navigation:
    title: "Get support"
    path: "/get-support"
    order: 3
page_header:
    partial: "shared/page_headers/image_header"
    title: "Get support"
    image:
        path: "content/supportbanner.png"
        alt: "A group of people seated indoors, attentively facing a presenter standing in front of a whiteboard."
---

<%= content_tag :div, class: "dfe-grid-container" do %>
    <%= render Cards::SimpleCardComponent.new(
        title: "Get support through your training", 
        description: "Find out what support you'll get as part of your teacher training course.",
        path: "get-support/get-support-through-your-training-course"
    ) %>
    <%= render Cards::SimpleCardComponent.new(
        title: "Get support outside your training", 
        description: "Find out what extra support you can get beyond your teacher training course.",
        path: "get-support/get-support-outside-your-training"
    ) %>
    <%= render Cards::SimpleCardComponent.new(
        title: "Funding information from Get Into Teaching", 
        description: "Find out what financial support you can get beyond your teacher training course.",
        path: "Https://getintoteaching.education.gov.uk/funding-and-support",
        data: {
            controller: "tracked-link",
            action: "click->tracked-link#track auxclick->tracked-link#track contextmenu->tracked-link#track",
            tracked_link_target: "link"
        }
    ) %>
<% end %>


