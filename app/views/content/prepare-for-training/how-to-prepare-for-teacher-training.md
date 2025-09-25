---
title: "How to prepare for teacher training"
layout: "article"
page_header:
    title: "How to prepare for teacher training"
    description: "Find out how you can prepare for your teacher training, from finding out about funding to reading advice from former trainees."
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
        - name: "How to prepare for teacher training"
          path: "/prepare-for-training/how-to-prepare-for-teacher-training"
---

<ul class="steps">
  <li class="step" id="step-1">
    <header class="step__header">
      <div class="step__number">
        <picture><%= image_tag "tick.svg" %></picture>
      </div>
      <h2 class="govuk-heading-l step_heading">1. Get classroom experience</h2>
    </header>
    <div class="step__content">
      <p class="govuk-body">
        Getting classroom experience can be a good way to help you feel more familiar with the school environment before you start your placement. Many providers recommend it.
      </p>

      <p class="govuk-body">
        You could arrange a few days in person with a school near you or <%= tracked_link_to "explore life in the classroom virtually on TeachQuest", "https://playcanv.as/b/ca743be9" %>.
      </p>

      <p class="govuk-body">
        You can also try the <%= tracked_link_to "realistic job preview tool", "https://platform.teachersuccess.co.uk/p/XK4rV0xN16/41xZQ10Z2l?id=c74fef2451c5af60c516075028d313d55321e06d2d53232082e329e292611d5b" %> where you can respond to realistic video scenarios to understand what life in the classroom is like.
      </p>

      <p class="govuk-body">
        You don't have to have classroom experience before you start training, but it could help you feel better prepared.
      </p>

      <%= render Cards::QuoteComponent.new(
          text: "Get as much experience in school as possible, as this tells you a lot about how schools work and function.",
          attribution: "Maths trainee from 2024/25",
          classes: "govuk-!-margin-bottom-5"
      ) %>

      <%= tracked_button_link_to "Get school experience", "https://getintoteaching.education.gov.uk/train-to-be-a-teacher/get-school-experience" %>
    </div>
  </li>

  <li class="step" id="step-2">
    <header class="step__header">
      <div class="step__number">
        <picture><%= image_tag "tick.svg" %></picture>
      </div>
      <h2 class="govuk-heading-l step_heading">2. Find out about funding</h2>
    </header>
    <div class="step__content">
      <p class="govuk-body">There are lots of different ways to fund your teacher training.</p>

      <p class="govuk-body">
        Depending on the subject you’re training to teach, you could be eligible for a scholarship or bursary.
      </p>

      <p class="govuk-body">
        You may also be entitled to extra support if you:
      </p>

      <ul class="govuk-list govuk-list--bullet">
        <li>are a parent or carer</li>
        <li>have a learning difficulty, health condition or disability</li>
        <li>are a veteran</li>
      </ul>

      <p class="govuk-body">
        You may also be eligible for some funding from your provider – you might want to speak to them about this before you start your course.
      </p>

      <%= tracked_button_link_to "Find out how to fund your training", "https://getintoteaching.education.gov.uk/funding-and-support" %>

    </div>
  </li>

  <li class="step" id="step-3">
    <header class="step__header">
      <div class="step__number">
        <picture><%= image_tag "tick.svg" %></picture>
      </div>
      <h2 class="govuk-heading-l step_heading">3. Talk to your training provider</h2>
    </header>
    <div class="step__content">
    
      <p class="govuk-body">Your training provider may have already been in touch and started your induction. Don't worry if not – many providers will wait until September.</p>

      <p class="govuk-body">You might want to think about any questions you have about your training to ask during your induction. For example, key milestones and assessments throughout the year and what support might be available.</p>

      <p class="govuk-body">You'll also need to update your provider if your circumstances have changed, for example, if you've moved as this could affect your placements.</p>

      <%= govuk_button_link_to "What to expect from your teacher training provider", "/prepare-for-training/what-to-expect-from-your-teacher-training-provider" %>

    </div>
  </li>

  <li class="step" id="step-4">
    <header class="step__header">
      <div class="step__number">
        <picture><%= image_tag "tick.svg" %></picture>
      </div>
      <h2 class="govuk-heading-l step_heading">4. Discuss any reasonable adjustments</h2>
    </header>
    <div class="step__content">
    
      <p class="govuk-body">Teacher training providers can make adjustments if you need support to become a teacher. This includes support for:</p>

      <ul class="govuk-list govuk-list--bullet">
        <li>neurodiversity</li>
        <li>long term physical health conditions</li>
        <li>mental health conditions</li>
        <li>accessibility needs</li>
      </ul>

      <p class="govuk-body">It’s best to talk to your provider about this as soon as possible to make sure you have all the support you need in place.</p>

      <%= tracked_button_link_to "Explore adjustments to help you train to teach", "https://getintoteaching.education.gov.uk/train-to-be-a-teacher/accessibility-adjustments" %>

    </div>
  </li>

  <li class="step" id="step-5">
    <header class="step__header">
      <div class="step__number">
        <picture><%= image_tag "tick.svg" %></picture>
      </div>
      <h2 class="govuk-heading-l step_heading">5. Read advice from former trainees</h2>
    </header>
    <div class="step__content">
      <p class="govuk-body">Prepare for your training by reading the advice of former trainee teachers from the 2024/25 academic year.</p>

      <%= govuk_button_link_to "Read advice from former trainees", "/prepare-for-training/advice-from-former-trainees" %>
    </div>
  </li>
</ul>
