# Developer Guide

## Table of Contents

 1. [Overview](#overview)
 2. [How pages work](#how-pages-work)
 3. [Navigation](#navigation)
 4. [Audience Generator](#audience-generator)

## Overview

Teacher Success aims to be a hub to help people through their teacher training journey. We provide guidance with the aim of improving teacher retention.

The site is fairly simple. We write content in markdown, and parse that into HTML to render as pages (see `ContentController`). This makes it easy for non-technical people to write and edit content for the site.

To facilitate extra options and features, designers can use front matter at the top of each markdown page to set important attributes like page titles, layouts and if the page should appear in the navigation.

Since we also parse the front matter, this provides a nice bridge to be able to use these attributes in the rails world.

## How pages work

Since pages are written in markdown, we use `app/services/content_loader.rb` to efficiently load and parse the markdown files, and `ContentController` to render them as views.

When the app starts, we assign an instance of `ContentLoader` to the `CONTENT_LOADER` constant which you can use throughout the app to access anything content. Since we wrap this in a `to_prepare` block, `CONTENT_LOADER` will automatically reload in development but only load once in production and test environments to ensure we're not parsing files on every request.

You can access a store of all content pages like this:

```
CONTENT_LOADER.pages
```

Parsed pages are stored in a hash where their key is the slug for the page (name without the markdown extension) and the value is a hash like this `{ front_matter: {}, content: "" }`

```
CONTENT_LOADER.pages["about"] # To get app/views/content/about.md
```

An better way to get `app/views/content/about.md` is to use `.find_by_slug` which returns front_matter and content at the same time, and will raise an error if the page is not found

```
front_matter, content = CONTENT_LOADER.find_by_slug("about")
```

The `ContentController` runs a before action to set `@front_matter` before rendering the page, so you can use this to access any config options for the page in the action or view

```
@front_matter.dig("title") # To get the title of app/views/content/about.md
```

## Navigation

Since `ContentLoader` loads and parses all the content pages, it also takes the opportunity to figure out which pages should be in the navigation by looking for ones with `navigation` in the front matter and returning them in the right order. See the content guidance docs for more on setting navigation properties of a page [docs/content.md](docs/content.md)

```
CONTENT_LOADER.navigation_items
```

## Audience Generator

We pull our audience from the [Candidate API](https://www.apply-for-teacher-training.service.gov.uk/candidate-api). There is a client wrapper for this in `app/services/candidate_api_client.rb`.

Since we want to do additional filtering on the data returned from this api. The data gets returned as a `CandidatesCollection` object (`app/lib/candidates_collection.rb`) so you can chain filtering methods on this.

For example, to fetch all candidates, then filter them down to recruited candidates:

```
candidates = CandidateApiClient.new.candidates.with_application_status(statuses: ["recruited"])
```

The second side of this is `app/services/audience_generator.rb` which is responsible for pulling the audience list and exporting it to a csv.

For example, to generate a new csv:

```
AudienceGenerator.new.export
```

This will export an `audience.csv` to the root of the project. Run this locally from `rails c -e production` to use the production credentials.
