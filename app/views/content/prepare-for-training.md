---
title: "Prepare for training"
navigation:
    title: "Prepare for training"
    path: "/prepare-for-training"
    order: 1
page_header:
    title: "Prepare for training"
    description: "Find out what to expect as part of your teacher training, including preparing for placement, what to expect from your mentor and advice from former trainees."
---

<%= content_tag :div, class: "dfe-grid-container" do %>
    <%= render Cards::SimpleCardComponent.new(
        title: "How to prepare for teacher training", 
        description: "Find out how you can prepare for your teacher training, from considering any reasonable adjustments you might need to finding out about funding.",
        path: root_path
    ) %>
    <%= render Cards::SimpleCardComponent.new(
        title: "Prepare for your first school placement", 
        description: "Find out how you can prepare for your first school placement, from accessing the school to your professional conduct.",
        path: root_path
    ) %>
    <%= render Cards::SimpleCardComponent.new(
        title: "What to ask your teacher training provider", 
        description: "Find out what you might want to ask your training provider to help you prepare for your teacher training, from assessment dates to access to technology.",
        path: root_path
    ) %>
<% end %>
