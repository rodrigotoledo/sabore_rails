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

- Rails 7, Hotwire/Turbo, Tailwind, Leaflet para mapas.
- Backend preparado para busca semântica com pgvector.

---

# Sabore Rails

Aplicação Rails 8 com integração ao Model Context Protocol (MCP) via [fast-mcp](https://github.com/yjacquin/fast-mcp).

## Principais tecnologias
- Ruby on Rails 8
- Turbo, Stimulus, TailwindCSS
- fast-mcp (MCP para LLM/AI)

## Como rodar o projeto

```bash
bundle install
rails db:setup
rails server
```

## Integração MCP (Model Context Protocol)

O projeto expõe recursos dos principais modelos via MCP, permitindo integração com LLMs e agentes externos.

### Endpoints MCP disponíveis

- `/mcp/resources/menu_items`
- `/mcp/resources/establishments`
- `/mcp/resources/users`
- `/mcp/resources/reservations`
- `/mcp/resources/categories`

Esses endpoints retornam os dados dos modelos em JSON, prontos para consumo por LLMs ou ferramentas MCP.

### Inspecionando o contexto MCP

Você pode usar o inspector oficial do MCP para explorar os recursos:

```bash
npx @modelcontextprotocol/inspector
```

## Adicionando novos recursos MCP

Basta criar um novo arquivo em `app/resources/` herdando de `ApplicationResource` e definir o método `content`.

## Referências
- [fast-mcp no GitHub](https://github.com/yjacquin/fast-mcp)
- [Model Context Protocol](https://modelcontext.org/)