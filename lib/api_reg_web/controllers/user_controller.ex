defmodule ApiRegWeb.UserController do
  use ApiRegWeb, :controller

  alias ApiReg.Accounts
  alias ApiReg.Accounts.Auth.Guardian
  alias ApiReg.Accounts.User

  action_fallback ApiRegWeb.FallbackController

  plug :control_access when action in [:index]

  def signup(conn, %{"user" => user}) do
    with {:ok, user, account} <- Accounts.create_user(user) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, id: user.id))
      |> render("account.json", %{user: user, account: account})
    end
  end

  def signin(conn, %{"cpf" => cpf, "password" => password}) do
    with {:ok, user, token} <- Guardian.authenticate(cpf, password) do
      conn
      |> put_status(:created)
      |> render("user_auth.json", user: user, token: token)
    end
  end

  def index(conn, _) do
    conn
    |> render("index.json", users: Accounts.get_users())
  end

  def show(conn, _) do
    user = Guardian.Plug.current_resource(conn)

    with %User{} = user <- Accounts.get_user!(user.id) do
      render(conn, "show.json", user: user)
    end
  end

  defp control_access(conn, _) do
    user = Guardian.Plug.current_resource(conn)

    if user.role == "admin" do
      conn
    else
      conn
      |> put_status(401)
      |> json(%{error: "You don't have authorization to do this."})
    end
  end
end
