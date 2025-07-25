# 💪 Teacher Success

## Installation

Clone the project and `cd` into it

```
bundle install
yarn install
./bin/dev
```

You'll need a copy of the credentials from another developer

## Credentials

We use `dotenv` to manage environment variables and credentials. Since `dotenv` loads things in precedence order (see:  https://github.com/bkeepers/dotenv?tab=readme-ov-file#customizing-rails), we can list everything in the `.env` file as a guide, and override things with environment specific files.

Not ignored / Safe to commit:

- `.env` - A full list of environment variables as a baseline (nothing sensitive)
- `.env.development` - Development environment variables that are safe to be committed

Ignored / Do not commit:

- `.env.development.local` - use to override Development variables with sensitive information
- `.env.test.local` - use to override Test variables with sensitive information

tl;dr - if you add a new env variable, document it in `.env`, add any safe config variables in the appropriate environment file. Use `.env.environment.local` files for sensitive information as these are ignored.

In review/staging/production we use keyvault to store credentials which are automatically pulled through and set in the deployment process.

## Documentation

- [Review Guide](docs/review.md)
- [Content Guide](docs/content.md)
- [Developer Guide](docs/development.md)

## Prerequisites

This project depends on:

  - [Ruby](https://www.ruby-lang.org/)
  - [Ruby on Rails](https://rubyonrails.org/)
  - [NodeJS](https://nodejs.org/)
  - [Yarn](https://yarnpkg.com/)
  - [Postgres](https://www.postgresql.org/)

