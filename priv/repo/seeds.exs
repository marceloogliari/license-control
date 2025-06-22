# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Licenca.Repo.insert!(%Licenca.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Licenca.Repo
alias Licenca.Admin.Status

Repo.insert!(%Status{
  description: "Ativo"
})

Repo.insert!(%Status{
  description: "Aviso"
})

Repo.insert!(%Status{
  description: "Bloqueado"
})

Repo.insert!(%Status{
  description: "Desativado"
})
