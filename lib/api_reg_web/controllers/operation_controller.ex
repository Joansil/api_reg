defmodule ApiRegWeb.OperationController do
  use ApiRegWeb, :controller

  alias ApiReg.Operations
  # alias ApiReg.Transactions.Report
  # alias ApiRegWeb.Auth.Guardian

  action_fallback ApiRegWeb.FallbackController

  def transfer(conn, %{"to" => to_id, "value" => value}) do
    user = Guardian.Plug.current_resource(conn)
    value = Decimal.new(value)

    with {:ok, message} <- Operations.transfer(user.accounts, to_id, value) do
      conn
      |> render("success.json", message: message)
    end
  end

  def deposit(conn, %{"to" => to_id, "value" => value}) do
    user = Guardian.Plug.current_resource(conn)
    value = Decimal.new(value)

    with {:ok, message} <- Operations.deposit(user.accounts, to_id, value) do
      conn
      |> render("success.json", message: message)
    end
  end

  def withdraw(conn, %{"value" => value}) do
    user = Guardian.Plug.current_resource(conn)
    value = Decimal.new(value)

    with {:ok, message} <- Operations.withdraw(user.accounts, value) do
      conn
      |> render("success.json", message: message)
    end
  end

  def chargeback(conn, %{"to_id" => to_id, "value" => value}) do
    user = Guardian.Plug.current_resource(conn)
    value = Decimal.new(value)

    with {:ok, message} <-
           Operations.chargeback(user.accounts, to_id, value) do
      conn
      |> render("success.json", message: message)
    end
  end
end
