# Content Guide

## Table of Contents

 1. [How we do Content](#how-we-do-content)
 2. [Frontmatter](#frontmatter)
    - [Title](#title)
    - [Description](#description)
    - [Layout](#layout)
    - [Navigation](#navigation)
    - [Page Header](#page-header)
    - [Variables](#variables)
    - [Side Navigation](#side-navigation)
    - [Breadcrumbs](#breadcrumbs)
 3. [Creating a new page](#creating-a-new-page)
 4. [Variables](#variables)
 5. [Rails Partials](#rails-partials)

## How we do Content

This site is built in Ruby on Rails but our content is made up of markdown files. 

It's good because you don't need to be technical to add content, you just need to know Markdown.

We've also built some extra features on top of markdown to add more rich content to pages.

## Frontmatter

Front matter is the stuff at the start of the markdown file that looks like this:

```
---
title: "Home"
description: "My home page"
layout: "blank"
navigation:
    title: "Home"
    path: "/"
    order: 1
page_header:
    partial "shared/page_headers/with_image"
    title: "Home Page Header"
    description: "Some description goes here"
variables:
    hello: "World"
---
```

It's used to set options for the page.

Here's some of the options you can set in the front matter:

### Title

This sets the html `title` for the page. Also used for `og:title` via yielding `page_title`.

### Description

Used for the `og:description`. Optional

### Layout

Optional. By default, pages will use the `views/layouts/application.html.erb` layout. You can specify another layout in the front matter.

```
layout: "blank"
```

### Navigation

To make a page appear in the main navigation, set a `navigation` property with a `title` (the text that will be used for the navigation item) and a `path` (where that navigation item will link to). You can also set order to determine the order in which the navigation items should appear in the menu.

```
navigation:
    title: "About"
    path: "/about"
    order: 2
```

### Page Header

Optional. If present, this will render a light blue header at the top of the page using the title and description provided.

```
page_header:
    title: "Teacher Training Hub"
    description: "Whether you want information on training, resources during training, or a space to connect with other trainees, the Teacher Training Hub is the place for all trainees."
```

To render a specific header for the page, you can override this with the path of the partial to load. Keep page header partials in `shared/page_headers` to keep things tidy. This gives you a lot of flexibility to render Components or use extra information like image paths.

```
page_header:
    partial: "shared/page_headers/with_image"
    title: "Teacher Training Hub"
    description: "Whether you want information on training, resources during training, or a space to connect with other trainees, the Teacher Training Hub is the place for all trainees."
    image:
        path: "content/teacher.png"
        alt: "An image of a teacher teaching a classroom of children"
```

For the `with_image` header, you can use `image` with `path` and `alt` to set the image within the header.

### Variables

You can set variables that you want to reuse in the content in the front matter. See the Variables section for more about this.

### Side Navigation

Side navigation is common in articles to give the user a way to jump to certain content (like a table of contents).

To use the side navigation, you'll need to set `layout: "article"`.

```
side_navigation:
    title: Prepare for training
    steps:
        - title: Trainee starter checklist
          href: "#trainee-starter-checklist"
        - title: Get school experience 
          href: "#get-school-experience"
        - title: Advice from past trainees 
          href: "#"
        - title: Trainee starter checklist 
          href: "#"
        - title: Timeline of your training year 
          href: "#"
        - title: Prepare for your first school placement 
          href: "#"
        - title: Learn about PGCE expectation and best practice
          href: "#"
```

### Breadcrumbs

Breadcrumbs are enabled by default. You can optionally disable or override them.

```
breadcrumbs:
    enabled: false
    crumbs:
        - name: Home
        - path: "/"
```


## Creating a new page

Content pages live under `app/views/content`, create an empty file in there. Naming should be all lowercase, hyphenated (if more than one word) and files should end in `.md`. You should try to name your file the same as the path it can be found at. For example `/about` should be called `about.md` and `/life-as-a-teacher/about` should be `app/views/content/life-as-a-teacher/about.md`. Note how the file structure follows the path structure.

Good:

`my-new-file.md`

Bad:

`MyFile.markdown`

Copy and paste some existing front matter from another page and amend the details as required.

## Variables

You can use variables within content to keep important values in a single location instead of hardcoding them.

A good example is if you want to mention a salary across many pages. If the salary were to change you'd have to change every occurance throughout the whole site. This is fine if you have a few pages but if you have hundreds it's a big job.

Since this value could be subject to change, it's better to create a variable for it to act as a placeholder, and reference that variable than to hardcode it everywhere. Then we can simply update the variable and it will change everywhere that variable is mentioned.

There are two ways of creating variables

You can put variables in the markdown file itself, or in `config/variables.yml`. 

If you're referencing the variable in more than one page, it's better going in `config/variables.yml`.

On a single page / putting it in the front matter...

```markdown
---
title: My Page
variables:
    salary: £30,000
---

Your salary will be $salary$.
```

In `config/variables.yml`

`config/variables.yml`
```yaml
salary: £30,000
```

`content/page.md`
```markdown
Your salary will be $salary$.
```

## Rails Partials

You can embed ERB tags within the markdown just like a normal `.html.erb` file.

Here's an example that calls a partial and uses a front matter variable within the partial...

`home.md`
```
---
title: "Home"
navigation:
    title: "Home"
    path: "/"
    order: 1
variables:
    card_title: "About"
---

# Home

<%= render "shared/card", { title: "$card_title$", href: "/about" } %>
```

If you need to do something complex like render a group of cards (all in their own partial), it's better to create a partial for it and reference that. Try to keep ERB in markdown to single line references of other partials to keep things neat.
