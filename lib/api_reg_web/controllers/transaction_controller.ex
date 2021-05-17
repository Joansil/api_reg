defmodule ApiRegWeb.TransactionController do
  use ApiRegWeb, :controller

  # alias ApiReg.Accounts
  # alias ApiReg.Accounts.User
  alias ApiReg.Transactions

  action_fallback(ApiRegWeb.FallbackController)

  # plug :control_access when action in [:all]

  def all(conn, _) do
    render(conn, "operation.json", operation: Transactions.all())
  end

  def year(conn, %{"year" => year}) do
    year = String.to_integer(year)
    render(conn, "operation.json", operation: Transactions.year(year))
  end

  def month(conn, %{"year" => year, "month" => month}) do
    year = String.to_integer(year)
    month = String.to_integer(month)
    render(conn, "operation.json", operation: Transactions.month(year, month))
  end

  def day(conn, %{"day" => day}) do
    render(conn, "operation.json", operation: Transactions.day(day))
  end

  #  defp control_access(conn, _) do
  #    user = Guardian.Plug.current_resource(conn)
  #
  #    if user.role == "admin" do
  #      conn
  #    else
  #      conn
  #      |> put_status(401)
  #      |> json(%{error: "You don't have authorization to do this."})
  #    end
  #  end
end
