defmodule ApiRegWeb.FallbackController do
  use ApiRegWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(ApiRegWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end

  def call(conn, {:error, :not_found, msg}) do
    conn
    |> put_status(:not_found)
    |> json(%{error: msg})
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> render(ApiRegWeb.ErrorView, :"401")
  end
end
