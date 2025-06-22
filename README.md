# License Control

## Requisitos
- Elixir 1.14+
- Phoenix 1.7+
- PostgreSQL (ou banco que usar)

## Setup
```bash
# Instalar dependências
mix deps.get

# Criar e migrar banco
mix ecto.setup

# Compilar assets
mix assets.setup

# Rodar servidor
mix phx.server