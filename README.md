# Mapzy

A privacy-first, self-hostable store finder.
## Contributing
### Development Setup with Docker

The simplest way to get your development setup running is via [Docker](https://www.docker.com/).

```
# Set the .env files and fill in all env vars
cp .env.example .env

# Build docker image
docker compose build

# Run the project
docker compose up -d

# Create and migrate the database
docker compose exec app bash
rails db:create db:migrats
exit
```

### Development Setup without Docker

Dependencies:
- ruby ~3.0.0
- rails ~6.1.3
- postgres ^13.2
- nodejs ^14.x

Install the dependencies on your machine & set up an user in postgres. Then:
```
# Set the .env files and fill in all env vars
cp .env.example .env

# Create and migrate the database
rails db:create db:migrate

# Finally, run the app locally
rails s
```

## License

This project uses the [GNU Affero General Public License v3.0](https://github.com/mapzy/mapzy/blob/main/LICENSE) license.
