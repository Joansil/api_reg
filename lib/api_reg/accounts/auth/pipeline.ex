defmodule ApiReg.Accounts.Auth.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :api_reg,
    module: ApiReg.Accounts.Auth.Guardian,
    error_handler: ApiReg.Auth.ErrorHandler

  plug(Guardian.Plug.VerifyHeader)
  plug(Guardian.Plug.EnsureAuthenticated)
  plug(Guardian.Plug.LoadResource)
end
