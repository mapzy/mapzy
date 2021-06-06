### Development Setup with Docker

The simplest way to get your development setup running is via [Docker](https://www.docker.com/).

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

### Development Setup without Docker

Dependencies:
- ruby ~3.0.0
- rails ~6.1.3
- postgres ^13.2

Install the dependencies on your machine & set up an user in postgres. Then:
```
# Set the .env files and fill in all env vars
cp .env.example .env
# Create and migrate the database
rails db:create db:migrate
# Finally, run the app locally
rails s -b 0.0.0.0
```