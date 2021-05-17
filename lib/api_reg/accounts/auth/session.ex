defmodule ApiReg.Accounts.Auth.Session do
  import Ecto.Query, warn: false
  alias ApiReg.Accounts.User
  alias ApiReg.Repo

  def authenticate(cpf, password) do
    query = from(u in User, where: u.cpf == ^cpf)

    case Repo.one(query) do
      nil ->
        Comeonin.Argon2.dummy_checkpw()
        {:error, :not_found}

      user ->
        if Argon2.verify_pass(password, user.password_hash) do
          {:ok, user |> Repo.preload(:accounts)}
        else
          {:error, :unauthorized}
        end
    end
  end
end
