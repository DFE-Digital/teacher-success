# Teacher Success

## Installation

Clone the project and `cd` into it

```
bundle install
yarn install
./bin/dev
```

## Content

For content guidance, see [docs/content.md](docs/content.md)

## How pages work

Since pages are written in markdown, we use `app/services/content_loader.rb` as a singleton to efficiently load and parse the markdown files, and `ContentController` to render them as views.

In production, `ContentLoader.instance.pages` will provide a list of pages that we load once on application startup to ensure we're not parsing markdown on every request. 

In development we bypass this and parse markdown on every request so you don't have to keep restarting your server to see changes.

You can access a store of all content pages like this:

```
ContentLoader.instance.pages

ContentLoader.instance.pages["about"] # To get app/views/content/about.md

front_matter, content = ContentLoader.instance.find_by_slug("about") # Alternative (safer) way to get app/views/content/about.md, and return front_matter and content at the same time, will raise an error if the page is not found

@front_matter.dig("title") # To get the title of app/views/content/about.md
```

Parsed pages are stored in a hash where their key is the slug for the page (name without the markdown extension) and the value is a hash like this `{ front_matter: {}, content: "" }`

Each page will also set `@front_matter`, in the controller so you can use this to access any config options for the page

### Navigation

Since `ContentLoader` loads and parses all the content pages, it also takes the opportunity to figure out which pages should be in the navigation by looking for ones with `navigation` in the front matter. See the content guidance docs for more on setting navigation properties of a page [docs/content.md](docs/content.md)

```
ContentLoader.instance.navigation_items
```

## Prerequisites

This project depends on:

  - [Ruby](https://www.ruby-lang.org/)
  - [Ruby on Rails](https://rubyonrails.org/)
  - [NodeJS](https://nodejs.org/)
  - [Yarn](https://yarnpkg.com/)
  - [Postgres](https://www.postgresql.org/)

