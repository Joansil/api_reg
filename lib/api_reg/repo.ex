defmodule ApiReg.Repo do
  use Ecto.Repo,
    otp_app: :api_reg,
    adapter: Ecto.Adapters.Postgres
end
