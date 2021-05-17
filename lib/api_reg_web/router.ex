defmodule ApiRegWeb.Router do
  use ApiRegWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug ApiReg.Accounts.Auth.Pipeline
  end

  scope "/auth", ApiRegWeb do
    post "/sign_up", UserController, :signup
    post "/sign_in", UserController, :signin
  end

  scope "/auth", ApiRegWeb do
    pipe_through [:api, :auth]

    # only admins
    get "/users", UserController, :index

    # common user
    get "/user", UserController, :show

    post "/operations/deposit", OperationController, :deposit
    post "/operations/transfer", OperationController, :transfer
    post "/operations/withdraw", OperationController, :withdraw
    post "/operations/chargeback", OperationController, :chargeback

    get "/transactions/all", TransactionController, :all
    get "/transactions/year/:year", TransactionController, :year
    get "/transactions/year/:year/month/:month", TransactionController, :month
    get "/transactions/day/:day", TransactionController, :day
  end
end
