
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