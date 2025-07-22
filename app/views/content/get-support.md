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
        path: "content/teacher.png"
        alt: "Image of a teacher teaching a classroom of children"
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
        path: "https://getintoteaching.education.gov.uk/funding-and-support"
    ) %>
<% end %>


