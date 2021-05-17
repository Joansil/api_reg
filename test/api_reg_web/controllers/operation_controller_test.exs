defmodule ApiRegWeb.OperationControllerTest do
  use ApiRegWeb.ConnCase, async: true

  alias ApiReg.Accounts.{Account, User}
  alias ApiReg.Operations

  describe "deposit/2" do
    setup %{conn: conn} do
      user = %{
        name: "Chikko",
        last_name: "Pankika",
        cpf: 04_995_876_352,
        password: "123456"
      }

      {:ok, %User{accounts: %Account{id: id}}} = ApiReg.Accounts.create_user(user)

      {:ok, conn: conn, id: id}
    end

    test "when all params is valid, deposit it", %{conn: conn, to_id: to_id} do
      value = %{"value" => "100.00"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit, to_id, value))
        |> json_response(:ok)

      assert %{
               "account" => %{"balance" => "100.00", "id" => _id},
               "message" => "Balance updated successfully!"
             } = response
    end

    test "when have some invalid params, returns a error", %{conn: conn, to_id: to_id} do
      value = %{"value" => "grana!"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit, to_id, value))
        |> json_response(400)

      expected_response = %{"message" => "Invalid deposit value"}

      assert response == expected_response
    end
  end
end
