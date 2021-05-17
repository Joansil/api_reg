defmodule ApiReg.Transactions.Report do
  use Ecto.Schema

  import Ecto.Changeset

  @derive {Phoenix.Param, key: :id}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @required_params [:value, :from, :to, :type, :date]

  schema "reports" do
    field(:value, :decimal)
    field(:from, :string)
    field(:to, :string)
    field(:type, :string)
    field(:date, :date)

    timestamps()
  end

  def changeset(report, params) do
    report
    |> cast(params, @required_params)
    |> validate_required(@required_params)
  end
end
