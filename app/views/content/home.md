---
title: "Home"
author: "Spencer Dixon"
date: "2025-05-12"
navigation:
    title: "Home"
    path: "/"
    order: 1
---

# Home

<%= content_tag :div, class: "dfe-grid-container" do %>
<%= render "shared/card", { title: "Home", href: "/" } %>
<%= render "shared/card", { title: "About", href: "/about" } %>
<%= render "shared/card", { title: "Nested", href: "/nested/page" } %>
<% end %>

<%= image_url "govuk-crest.svg" %>
