---
title: "Prepare for training"
navigation:
    title: "Prepare for training"
    path: "/prepare-for-training"
    order: 1
page_header:
    partial: "shared/page_headers/image_header"
    title: "Prepare for training"
    description: "Find out what to expect as part of your teacher training, including preparing for placement, what to expect from your mentor and advice from former trainees."
    image:
        path: "content/teacher.png"
        alt: "Teacher engaging with enthusiastic secondary school students raising their hands in a classroom decorated with reading materials."
---

<%= content_tag :div, class: "dfe-grid-container" do %>
    <%= render Cards::SimpleCardComponent.new(
        title: "How to prepare for teacher training", 
        description: "Find out how you can prepare for your teacher training, from finding out about funding to reading advice from former trainees.",
        path: "/prepare-for-training/how-to-prepare-for-teacher-training"
    ) %>
    <%= render Cards::SimpleCardComponent.new(
        title: "How to prepare for your first school placement", 
        description: 'Find out how you can prepare for your first school placement, from accessing the school to your professional conduct.',
        path: "/prepare-for-training/prepare-for-your-first-school-placement"
    ) %>
    <%= render Cards::SimpleCardComponent.new(
        title: "What to expect from your teacher training provider", 
        description: "Find out what information you can expect to get from your training provider when you start your training, from assessment dates to available support.",
        path: "/prepare-for-training/what-to-expect-from-your-teacher-training-provider"
    ) %>
    <%= render Cards::SimpleCardComponent.new(
        title: "What to expect from your school-based mentor", 
        description: "Find out what to expect from your school-based mentor, how they’ll assess you and where else you can get support.",
        path: "/prepare-for-training/what-to-expect-from-your-school-based-mentor"
    ) %>
    <%= render Cards::SimpleCardComponent.new(
        title: "Timeline of your training", 
        description: "Find out what happens and when on initial teacher training (ITT), whether you’re training with a university or doing school centred initial teacher training (SCITT).",
        path: "/prepare-for-training/timeline-of-your-training"
    ) %>
    <%= render Cards::SimpleCardComponent.new(
        title: "Advice from former trainees", 
        description: "Hear from former trainees and their advice for teacher training.",
        path: root_path
    ) %>
<% end %>
