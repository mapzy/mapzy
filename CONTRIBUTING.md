## Contribution Guide

## Contribution Rules

This is an open-source project and we welcome contributions that improve the code, UX/UI and add new features. However, this doesn't mean that we will accept all contributions. The best way to contribute is to check the open issues.
If you want to contribute, fork this repo and create a pull request with your changes that we can review.

If you have any questions, head over to our [GitHub Discussions](https://github.com/mapzy/mapzy/discussions) page.

## Development

### Setup

There are a few ways you can get started with Mapzy on your local machine.

### Locally on your dev environment

Dependencies:
- ruby >= 3.3.0
- rails >= 7.1.0
- postgres >= 14.0

Install the dependencies on your machine & set up an user in Postgres. Then:
```
# Set the .env files and fill in all env vars
cp .env.example .env

# Create and migrate the database
rails db:create db:migrate
```

### Gitpod
We've included a Gitpod setup so you can use the cloud-baed development environment provided by Gitpod](gitpod.io/). To start your ready-to-code development enviroment just add `gitpod.io/#` in front of the GitHub URL for any branch, or [click here](https://gitpod.io/#https://github.com/mapzy/mapzy) to get started with the main branch. Don't forget to add the environment variables from `.env.example` to your Gitpod account.

### Docker

You can build the Docker image using the `Dockerfile.dev` configuration. If you don't want to run Postgres manually, you can use our `docke-compose` file to start them via Docker. Just run `docker-compose -f docker-compose.dev.yml up`.

Don't forget to create an `.env` file using `.env.example` as a template.

If you're not using `docker-compose`, make sure to create the database with `docker run --env-file .env your_image rails db:create` before starting the Rails server.

## Starting the development server
To start the server, run `.foreman start -f Procfile.dev`. This starts the Rails server, the Tailwind watch process and the Sidekiq process.


## Mapzy Cloud
There are a few places in the codebase where you will encounter logic that is only needed for Mapzy Cloud, the hosted solution by us. These parts of the code are not needed if you are self-hosting, and probably also not relevant for you as a contributor. For the most part this concerns code that relates to payment and subscriptions.

Currently, we use the environment variable `MAPZY_CLOUD` to determine if the instance is being self-hosted or not.

Note: We stopped providing a hosted version of Mapzy for now, but the Mapzy Cloud logic described above is still in the codebase.