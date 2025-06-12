---
title: "Get Ready to Teach"
author: "Spencer Dixon"
date: "2025-05-12"
navigation:
    title: "Home"
    path: "/"
    order: 1
page_header:
    title: "Get Ready to Teach"
    description: "Whether you want information on training, resources during training, or a space to connect with other trainees, the Teacher Training Hub is the place for all trainees."
    logo: true
breadcrumbs:
    enabled: false
---

<%= render "shared/components/horizontal_card", 
title: "Tips to prepare for your training year",
description: "Find out what happens and when during your training year whether you’re on a university or school led teacher training programme.",
button_text: "Find out more",
button_href: "/"
%>

## Your next steps to feeling placement ready

<%= content_tag :div, class: "dfe-grid-container" do %>
<%= render "shared/card", { title: "Home", href: "/" } %>
<%= render "shared/card", { title: "About", href: "/about" } %>
<%= render "shared/card", { title: "Nested", href: "/nested/page" } %>
<% end %>
