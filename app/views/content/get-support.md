---
title: "Get support"
navigation:
    title: "Get support"
    path: "/get-support"
    order: 3
page_header:
    title: "Get support"
---

<%= content_tag :div, class: "dfe-grid-container" do %>
    <%= render Cards::SimpleCardComponent.new(
        title: "Get support through your training", 
        description: "Find out what support you'll get as part of your teacher training course.",
        path: root_path
    ) %>
    <%= render Cards::SimpleCardComponent.new(
        title: "Get support outside your training", 
        description: "Find out what support you'll get as part of your teacher training course.",
        path: root_path
    ) %>
<% end %>


