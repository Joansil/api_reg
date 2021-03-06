defmodule ApiRegWeb.UserView do
  use ApiRegWeb, :view

  def render("account.json", %{user: user, account: account}) do
    %{
      balance: account.balance,
      account_id: account.id,
      user: %{
        id: user.id,
        name: user.name,
        last_name: user.last_name,
        cpf: user.cpf,
        role: user.role
      }
    }
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, __MODULE__, "user.json")}
  end

  def render("user_auth.json", %{user: user, token: token}) do
    user = Map.put(render_one(user, __MODULE__, "user.json"), :token, token)
    %{data: user}
  end

  def render("index.json", %{users: users}) do
    %{data: render_many(users, __MODULE__, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      name: user.name,
      last_name: user.last_name,
      cpf: user.cpf,
      role: user.role,
      account: %{
        balance: user.accounts.balance,
        id: user.accounts.id
      }
    }
  end
end
