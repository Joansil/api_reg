defmodule ApiReg.Accounts.UserTest do
  use ApiReg.DataCase, async: true

  alias ApiReg.Accounts.{Account, User}

  describe "call/1" do
    test "when all params is valid, returns an user" do
      params = %{
        name: "Chikko",
        last_name: "Pankika",
        cpf: 04_995_876_352,
        password: "123456"
      }

      {:ok, %ApiReg.Accounts.User{id: user_id}} = ApiReg.Accounts.create_user(params)
      user = ApiReg.Repo.get(User, user_id)

      assert %ApiReg.Accounts.User{
               name: "Chikko",
               last_name: "Pankika",
               cpf: 04_995_876_352,
               id: ^user_id
             } = user
    end

    test "when there are invalid params, returns an error" do
      params = %{
        name: Ch1kk0,
        password: ""
      }

      {:error, changeset} = ApiReg.Accounts.create_user(params)

      expected_response = %{
        name: ["is invalid"],
        last_name: ["can't be blank"],
        cpf: ["can't be blank"],
        password: ["can't be blank"]
      }

      assert errors_on(changeset) == expected_response
    end
  end
end
