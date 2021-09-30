## Development

## Gitpod

We recommend developing with the excellent cloud-based development environment provided by [Gitpod](gitpod.io/). To start your ready-to-code development enviroment just add `gitpod.io/#` in front of the GitHub URL for any branch, or [click here](https://gitpod.io/#https://github.com/mapzy/mapzy) to get started with the main branch.

Run `foreman start -f Procfile.dev` to start the Rails server and the Webpack Dev Server (or run the processes in separate terminals manually).

## Docker

Getting up and running with Docker is also simple:

```
# Set the .env files and fill in all env vars
cp .env.example .env
# Build docker image (only once)
docker-compose build
# Create and migrate the database
docker-compose run app rake db:create db:migrate
# Finally, run the project
docker-compose up
```

### Old school

Dependencies:
- ruby ~3.0.0
- rails ~6.1.3
- postgres ^13.2
- redis ^5.07

Install the dependencies on your machine & set up an user in Postgres. Then:
```
# Set the .env files and fill in all env vars
cp .env.example .env
# Create and migrate the database
rails db:create db:migrate
# Finally, run the app locally
rails s -b 0.0.0.0
```

Run `foreman start -f Procfile.dev` to start the Rails server and the Webpack Dev Server (or run the processes in separate terminals manually).