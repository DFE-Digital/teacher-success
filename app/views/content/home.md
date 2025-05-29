---
title: "Teacher Training Hub"
author: "Spencer Dixon"
date: "2025-05-12"
navigation:
    title: "Home"
    path: "/"
    order: 1
page_header:
    title: "Teacher Training Hub"
    description: "Whether you want information on training, resources during training, or a space to connect with other trainees, the Teacher Training Hub is the place for all trainees."
---

<%= content_tag :div, class: "dfe-grid-container" do %>
<%= render "shared/card", { title: "Home", href: "/" } %>
<%= render "shared/card", { title: "About", href: "/about" } %>
<%= render "shared/card", { title: "Nested", href: "/nested/page" } %>
<% end %>
