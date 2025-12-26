# Sabore Rails

Aplicação Rails para busca e reservas de restaurantes, com integração a mapas e busca inteligente.

## Subindo o projeto com Docker

1. **Pré-requisitos**
   - Docker e Docker Compose instalados

2. **Subir os containers**
   ```sh
   docker-compose up --build
   ```

3. **Instalar gems**
   ```sh
   docker-compose run web bundle install
   ```

4. **Criar e migrar o banco**
   ```sh
   docker-compose run web rails db:create db:migrate
   ```

5. **Habilitar extensão pgvector**
   ```sh
   docker-compose run web rails generate migration enable_pgvector_extension
   # Edite a migration gerada:
   # def change
   #   enable_extension "vector"
   # end
   docker-compose run web rails db:migrate
   ```

6. **Acessar a aplicação**
   - http://localhost:3000

## Configuração do banco

- O banco usa PostgreSQL com a extensão [pgvector](https://github.com/pgvector/pgvector).
- As credenciais estão em `config/database.yml` e no `docker-compose.yml`.

## Busca inteligente

- Para busca semântica, integre com IA (ex: OpenAI embeddings ou pgvector).
- Exemplo de filtro tradicional por categoria:
  ```ruby
  Establishment.joins(:categories).where(categories: { name: params[:category] })
  ```

## Comandos úteis

- Instalar gems: `docker-compose run web bundle install`
- Migrar banco: `docker-compose run web rails db:migrate`
- Rodar seeds: `docker-compose run web rails db:seed`
- Console Rails: `docker-compose run web rails console`

## Estrutura

- Rails 8, Hotwire/Turbo, Tailwind, Leaflet para mapas.
- Backend preparado para busca semântica com pgvector.



## Putting In Development Mode

Whereas It Is Necessary To Run With Your User, Run

```bash
id -u
```

And Change The Dockerfile.Development File With The Value You Found

So Build You Just Need To Run The First Time:

```bash
docker compose -f docker-compose.development.yml build
```

And To Climb The Application Rode:

```bash
docker compose -f docker-compose.development.yml up
docker compose -f docker-compose.development.yml down
docker compose -f docker-compose.development.yml run app bash
docker compose -f docker-compose.development.yml run app rails active_storage:install
```

## Migrations

To Run Migrations, Tests ... Etc, Run The App With Whatever Is Needed:

```bash
docker compose -f docker-compose.development.yml run app rails db:drop db:create db:migrate
```

## Rails Commands

Example Of Interaction Between Computer and Container:

```bash
docker compose -f docker-compose.development.yml run app rails c
docker compose -f docker-compose.development.yml run app rails g scaffold post title
docker compose -f docker-compose.development.yml run app rails g scaffold comment post:references comment:text
```

Clean docker

```bash
docker stop $(docker ps -aq) || true
docker rm $(docker ps -aq) || true
docker rmi $(docker images -q) || true
docker volume rm $(docker volume ls -q) || true
docker network prune -f || true
docker image prune -a -f || true
docker system prune -a --volumes -f || true
docker builder prune -a -f || true
rm .db-created
rm .db-seeded
```
