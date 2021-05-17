defmodule ApiRegWeb.UserViewTest do
  use ApiRegWeb.ConnCase, async: true

  import Phoenix.View

  alias ApiReg.Accounts.{Account, User}
  alias ApiRegWeb.UserView

  test "render account.json" do
    params = %{
      name: "Chikko",
      last_name: "Pankika",
      cpf: 04_995_876_352,
      password: "123456"
    }

    {:ok, %User{id: user_id}, accounts: %Account{id: account_id} = user} =
      ApiReg.Accounts.create_user(params)

    response = render(UsersView, "account.json", user: user)

    expected_response = %{
      balance: user.account.balance,
      id: user.account.id,
      user: %{
        id: user.id,
        name: user.name,
        last_name: user.last_name,
        cpf: user.cpf,
        role: user.role
      }
    }

    assert expected_response == response
  end
end
