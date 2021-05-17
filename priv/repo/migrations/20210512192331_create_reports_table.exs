defmodule ApiReg.Repo.Migrations.CreateReportsTable do
  use Ecto.Migration

  def change do
    create table(:reports) do
      add(:value, :decimal, precision: 10, scale: 2)
      add(:from, :string)
      add(:to, :string)
      add(:type, :string)
      add(:date, :date)

      timestamps()
    end
  end
end
