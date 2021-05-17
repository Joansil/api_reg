defmodule ApiReg.Repo.Migrations.CreateUserTable do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :last_name, :string
      add :cpf, :string
      add :password, :string, virtual: true
      add :password_hash, :string
      add :role, :string

      timestamps()
    end

    create unique_index(:users, [:cpf])
  end
end
