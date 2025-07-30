---
title: "Timeline of your training"
layout: "article"
draft: true
page_header:
    title: "Timeline of your training"
    description: "Find out what happens and when on initial teacher training (ITT) whether you’re training with a university or doing school centred initial teacher training (SCITT)."
side_navigation:
    title: Prepare for training
    steps:
        - title: How to prepare for teacher training
          href: "/prepare-for-training/how-to-prepare-for-teacher-training"
        - title: Prepare for your first school placement
          href: "/prepare-for-training/prepare-for-your-first-school-placement"
        - title: What to expect from your teacher training provider
          href: "/prepare-for-training/what-to-expect-from-your-teacher-training-provider"
        - title: What to expect from your school-based mentor
          href: "/prepare-for-training/what-to-expect-from-your-school-based-mentor"
        - title: Advice from former trainees
          href: "/prepare-for-training/advice-from-former-trainees"
breadcrumbs: 
    enable: true
    crumbs: 
        - name: "Prepare for training"
          path: "/prepare-for-training"
        - name: "Timeline of your training"
          path: "/prepare-for-training/timeline-of-your-training"
---

What happens exactly on your teacher training course and when will depend on your specific training provider.

If you're doing a part-time course, your training will take place over a slightly longer period but should still include much of the following.

<%= govuk_tabs do |tabs| %>
    <%= tabs.with_tab(label: "If you're training with a SCITT") do %>
        <%= render("content/prepare-for-training/timeline-of-your-training/if_youre_training_with_a_scitt") %>
    <% end %> 
    <%= tabs.with_tab(label: "If you're training with a university") do %>
        <%= render("content/prepare-for-training/timeline-of-your-training/if_youre_training_with_a_university") %>
    <% end %> 
<% end %>

