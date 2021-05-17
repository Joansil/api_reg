defmodule ApiReg.Accounts.User do
  use Ecto.Schema

  import Brcpfcnpj.Changeset
  import Ecto.Changeset

  alias ApiReg.Accounts.Account
  alias Ecto.Changeset

  @derive {Phoenix.Param, key: :id}

  @primary_key {:id, :binary_id, autogenerate: true}

  @required_params [:name, :last_name, :cpf, :password, :role]

  schema "users" do
    field(:name, :string)
    field(:last_name, :string)
    field(:cpf, :string)
    field(:password, :string, virtual: true)
    field(:password_hash, :string)
    field(:role, :string, default: "user")

    has_one(:accounts, Account)

    timestamps()
  end

  def changeset(user, params) do
    user
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> validate_length(:name, min: 3)
    |> validate_length(:password, min: 6)
    |> validate_format(:name, ~r/^[[:alpha:]]+$/, message: "Name have to be only letters.")
    |> validate_format(:last_name, ~r/^[[:alpha:]]+$/,
      message: "Last name have to be only letters."
    )
    |> validate_format(:cpf, ~r/^[[:digit:]]+$/, message: "Cpf have to be only numbers.")
    |> validate_cpf(:cpf)
    |> unique_constraint(:cpf, message: "Have to be just one Cpf for each user")
    |> put_password_hash()
  end

  defp put_password_hash(%Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Argon2.add_hash(password))
  end

  defp put_password_hash(changeset), do: changeset
end
