---
title: "Resources while training"
navigation:
    title: "Resources while training"
    path: "/resources-while-training"
    order: 2
page_header:
    partial: "shared/page_headers/image_header"
    title: "Resources while training"
    image:
        path: "content/resourcesbanner.png"
        alt: "Three teachers walk together and talk in a school corridor, smiling and engaged in conversation."
---

<%= content_tag :div, class: "dfe-grid-container" do %>
    <%= render Cards::SimpleCardComponent.new(
        title: "Lesson planning as a trainee teacher", 
        description: "Find out how lesson planning works as part of your training and explore example lesson planning resources.",
        path: "resources-while-training/lesson-planning-as-a-trainee-teacher"
    ) %>
    <%= render Cards::SimpleCardComponent.new(
        title: "Behaviour management", 
        description: "Find out what you need to know about behaviour management as part of your teacher training along with links to resources and tips for new teachers.",
        path: "resources-while-training/behaviour-management"
    ) %>
    <%= render Cards::SimpleCardComponent.new(
        title: "Meeting the teachers' standards", 
        description: "Find out what the teachers’ standards are that you’ll need to meet to achieve qualified teacher status and how you might be asked to evidence them.",
        path: "resources-while-training/meeting-the-teachers-standards"
    ) %>
<% end %>

