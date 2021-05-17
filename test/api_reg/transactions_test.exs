defmodule ApiReg.TransactionsTest do
  use ApiReg.DataCase, async: true

  alias ApiReg.Transactions

  describe "transactions" do
    alias ApiReg.Transactions.Report

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def settings_transaction(attrs \\ %{}) do
      {:ok, transaction} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Transactions.change_transaction()

      transaction
    end

    test "all/0 returns all transactions" do
      transaction = settings_transaction()
      assert Transactions.all() == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id" do
      transaction = settings_transaction()
      assert Transactions.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid params return a transaction" do
      assert {:ok, %Report{} = transaction} = Transactions.create_transaction(@valid_attrs)
    end

    test "create_transaction/1 with invalid params returns a changeset error" do
      assert {:error, %Ecto.Changeset{}} = Transactions.create_transaction(@valid_attrs)
    end

    test "update_transaction/2 with valid params updates the transaction" do
      transaction = settings_transaction()

      assert {:ok, %Report{} = transaction} =
               Transactions.update_transaction(transaction, @update_attrs)
    end

    test "update_transaction/2 with invalid data returns a changeset error" do
      transaction = settings_transaction()

      assert {:error, %Ecto.Changeset{}} =
               Transactions.update_transaction(transaction, @invalid_attrs)

      assert transaction == Transactions.get_transaction!(transaction.id)
    end

    test "delete_transaction/1 deletes the transaction" do
      transaction = settings_transaction()
      assert {:ok, %Report{}} = Transactions.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> Transactions.get_transaction!(transaction.id) end
    end

    test "change_transaction/1 returns a changeset of a transaction" do
      transaction = settings_transaction()
      assert %Ecto.Changeset{} = Transactions.change_transaction(transaction)
    end
  end
end
